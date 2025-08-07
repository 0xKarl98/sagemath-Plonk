# Exercise 10: KZG Polynomial Commitment Verification
# This exercise implements the verification function for KZG polynomial evaluation proofs
# Reference: https://plonk.zksecurity.xyz/2_Schwartz-Zippel_Zero-Testing_and_Commitments/7_Verification.html

# Import necessary definitions from previous exercises
p = 21888242871839275222246405745257275088548364400416034343698204186575808495617
F = GF(p)
R.<x> = PolynomialRing(F, 'x')
n = Integer(21888242871839275222246405745257275088548364400416034343698204186575808495617)

# Define interpolation function
def interpolate(I, Y):
    """Lagrange interpolation polynomial"""
    n = len(I)
    f = 0
    for j in range(n):
        L_j = 1
        for i in range(n):
            if i != j:
                L_j *= (x - I[i]) / (I[j] - I[i])
        f += Y[j] * L_j
    return f

# Load elliptic curve setup from exercise7
# BN254 curve parameters
q = 21888242871839275222246405745257275088696311157297823662689037894645226208583

# Define the base field
Fq = GF(q)

# Define BN254 elliptic curve: y^2 = x^3 + 3
E = EllipticCurve(Fq, [0, 3])

# Generator points for G1 and G2
P_x = 1
P_y = 2
P = E(P_x, P_y)

# For G2, we need a different generator point
# In practice, this would be properly defined for BN254
# For this exercise, we'll use a simplified approach
Fq2.<i> = GF(q^2, modulus=x^2+1)
E2 = EllipticCurve(Fq2, [0, 3])

# G2 generator point (simplified for demonstration)
Q_x = Fq2([10857046999023057135944570762232829481370756359578518086990519993285655852781, 11559732032986387107991004021392285783925812861821192530917403151452391805634])
Q_y = Fq2([8495653923123431417604973247489272438418190587263600148770280649306958101930, 4082367875863433681332203403145435568316851327593401208105741076214120093531])
Q = E2(Q_x, Q_y)

# KZG Trusted Setup Parameters
τ = 424242  # Toxic waste
l = 10      # Maximum polynomial degree

print("=== Exercise 10: KZG Polynomial Commitment Verification ===")
print(f"Using trusted setup with τ = {τ}, l = {l}")

# Compute S1 = [P, τ⋅P, τ²⋅P, ..., τˡ⋅P]
S1 = []
for i in range(l + 1):
    tau_power_i = pow(τ, i, n)  # τ^i mod n
    S1_i = tau_power_i * P      # τ^i ⋅ P
    S1.append(S1_i)

# Compute S2 = [Q, τ⋅Q, τ²⋅Q, ..., τˡ⋅Q]
S2 = []
for i in range(l + 1):
    tau_power_i = pow(τ, i, n)  # τ^i mod n
    S2_i = tau_power_i * Q      # τ^i ⋅ Q
    S2.append(S2_i)

print(f"S1 computed: {len(S1)} G1 points")
print(f"S2 computed: {len(S2)} G2 points")

# Define the Fibonacci example polynomial a(x)
I = [1, 2, 3, 4]
a_values = {1: 0, 2: 1, 3: 1, 4: 3}  # Left input values from Fibonacci example
a = interpolate(I, list(a_values.values()))

print(f"\nFibonacci polynomial a(x): {a}")
print(f"Polynomial degree: {a.degree()}")

# Commitment function from exercise8
def commitment(S1, p):
    """
    Commitment function for KZG polynomial commitments.
    
    Args:
        S1: List of G1 points [P, τP, τ²P, ..., τˡP] from trusted setup
        p: Polynomial to commit to
    
    Returns:
        c: Commitment point on elliptic curve (equivalent to p(τ)⋅P)
    """
    # Get polynomial coefficients (pad with zeros if needed)
    coeffs = p.coefficients(sparse=False)
    
    # Ensure we don't exceed the trusted setup degree
    if len(coeffs) > len(S1):
        raise ValueError(f"Polynomial degree {len(coeffs)-1} exceeds trusted setup degree {len(S1)-1}")
    
    # Compute commitment: ∑i=0^l ai⋅S1[i] = a0⋅P + a1⋅τ⋅P + a2⋅τ²⋅P + ... + al⋅τˡ⋅P
    c = S1[0] * 0  # Initialize to point at infinity (neutral element)
    
    for i in range(len(coeffs)):
        ai = Integer(coeffs[i])  # Coefficient ai
        c = c + ai * S1[i]       # Add ai⋅S1[i] to commitment
    
    return c

# Proof function from exercise9
def proof(S1, Qc):
    """
    Generate a KZG proof for polynomial evaluation.
    
    Args:
        S1: List of G1 points [P, τP, τ²P, ..., τˡP] from trusted setup
        Qc: Quotient polynomial Qc(x) = (f(x) - f(γ)) / (x - γ)
    
    Returns:
        π: Proof point on elliptic curve (equivalent to Qc(τ)⋅P)
    """
    # Get polynomial coefficients (pad with zeros if needed)
    coeffs = Qc.coefficients(sparse=False)
    
    # Ensure we don't exceed the trusted setup degree
    if len(coeffs) > len(S1):
        raise ValueError(f"Polynomial degree {len(coeffs)-1} exceeds trusted setup degree {len(S1)-1}")
    
    # Compute proof: π = ∑i=0^l bi⋅S1[i] = b0⋅P + b1⋅τ⋅P + b2⋅τ²⋅P + ... + bl⋅τˡ⋅P
    # This is equivalent to π = Qc(τ)⋅P
    π = S1[0] * 0  # Initialize to point at infinity (neutral element)
    
    for i in range(len(coeffs)):
        bi = Integer(coeffs[i])  # Coefficient bi
        π = π + bi * S1[i]       # Add bi⋅S1[i] to proof
    
    return π

# Verification function - Exercise 10
def verification(c, π, γ, b):
    """
    Verify a KZG polynomial evaluation proof.
    
    Args:
        c: Commitment to polynomial f(x) (point on G1)
        π: Proof that f(γ) = b (point on G1)
        γ: Challenge point
        b: Claimed evaluation f(γ)
    
    Returns:
        bool: True if proof is valid, False otherwise
    
    The verification checks the pairing equation:
    e(π, S2 - γ⋅Q) = e(c - b⋅P, Q)
    
    This is equivalent to checking:
    e(π, (τ - γ)⋅Q) = e((f(τ) - f(γ))⋅P, Q)
    
    Which verifies that:
    π = Qc(τ)⋅P where Qc(x) = (f(x) - f(γ)) / (x - γ)
    """
    # Compute S2[1] - γ⋅Q = τ⋅Q - γ⋅Q = (τ - γ)⋅Q
    tau_minus_gamma_Q = S2[1] - Integer(γ) * Q
    
    # Compute c - b⋅P = f(τ)⋅P - f(γ)⋅P = (f(τ) - f(γ))⋅P
    c_minus_b_P = c - Integer(b) * P
    
    # Check the pairing equation: e(π, (τ - γ)⋅Q) = e((f(τ) - f(γ))⋅P, Q)
    # Left side: e(π, S2[1] - γ⋅Q)
    left_pairing = π.weil_pairing(tau_minus_gamma_Q, n)
    
    # Right side: e(c - b⋅P, Q)
    right_pairing = c_minus_b_P.weil_pairing(Q, n)
    
    # Return True if pairings are equal
    return left_pairing == right_pairing

# Test the complete KZG scheme
print("\n=== Testing Complete KZG Scheme ===")

# Step 1: Commit to polynomial a(x)
c = commitment(S1, a)
print(f"Commitment c = {c}")

# Step 2: Prover receives challenge γ
γ = 151515
print(f"\nChallenge γ = {γ}")

# Step 3: Prover computes evaluation b = a(γ)
b = a(γ)
print(f"Evaluation b = a(γ) = {b}")

# Step 4: Prover computes quotient polynomial and proof
Qc = (a - b) // (x - γ)
π = proof(S1, Qc)
print(f"\nQuotient polynomial Qc(x) = {Qc}")
print(f"Proof π = {π}")

# Step 5: Verifier checks the proof
print("\n=== Verification ===")
verification_result = verification(c, π, γ, b)
print(f"Verification result: {verification_result}")

# Additional verification using direct computation
print("\n=== Direct Verification ===")
# Verify that π = Qc(τ)⋅P
Qc_at_tau = Qc(τ)
expected_π = Integer(Qc_at_tau) * P
print(f"Qc(τ) = {Qc_at_tau}")
print(f"Expected π = Qc(τ)⋅P = {expected_π}")
print(f"Proof matches expected: {π == expected_π}")

# Verify that c = a(τ)⋅P
a_at_tau = a(τ)
expected_c = Integer(a_at_tau) * P
print(f"a(τ) = {a_at_tau}")
print(f"Expected c = a(τ)⋅P = {expected_c}")
print(f"Commitment matches expected: {c == expected_c}")

# Test assertion from the exercise
assert verification(c, π, γ, b) == True
print("\n✓ Assertion passed: verification(c, π, γ, b) == True")

print("\n=== Summary ===")
print("✓ Verification function implemented successfully")
print("✓ Complete KZG scheme tested:")
print("  1. Trusted setup (S1, S2) computed")
print("  2. Polynomial a(x) committed to c")
print("  3. Challenge γ received")
print("  4. Evaluation b = a(γ) computed")
print("  5. Proof π generated")
print("  6. Verification successful")
print("✓ Pairing equation verified: e(π, S2-γ⋅Q) = e(c-b⋅P, Q)")
print("✓ KZG polynomial commitment scheme complete!")

print("\n=== Implementation Notes ===")
print("This implementation demonstrates:")
print("1. Bilinear pairing verification using Weil pairing")
print("2. G1 and G2 group operations")
print("3. Complete KZG polynomial commitment workflow")
print("4. Verification of polynomial evaluation without revealing the polynomial")
print("5. The power of pairings in cryptographic protocols")

print("\n=== Important Notes ===")
print("1. This uses simplified BN254 curve parameters for demonstration")
print("2. In production, use proper pairing libraries (e.g., py_ecc, arkworks)")
print("3. The Weil pairing is used here; Tate pairing is more efficient in practice")
print("4. Proper G2 point generation requires careful implementation")
print("5. This completes the KZG polynomial commitment scheme tutorial")

print("\n✓ Exercise 10 completed: KZG Polynomial Commitment Verification")