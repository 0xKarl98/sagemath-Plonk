# Exercise 8: KZG Polynomial Commitment Function
# This exercise implements the commitment function for KZG polynomial commitments
# Reference: https://plonk.zksecurity.xyz/2_Schwartz-Zippel_Zero-Testing_and_Commitments/5_Commitments.html

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

# Generator points for G1
P_x = 1
P_y = 2
P = E(P_x, P_y)

# KZG Trusted Setup Parameters (from exercise7)
τ = 424242  # Toxic waste
l = 10      # Maximum polynomial degree

print("=== Exercise 8: KZG Polynomial Commitment Function ===")
print(f"Using trusted setup with τ = {τ}, l = {l}")

# Compute S1 = [P, τ⋅P, τ²⋅P, ..., τˡ⋅P] (from exercise7)
print("\nComputing S1 from trusted setup...")
S1 = []
for i in range(l + 1):
    tau_power_i = pow(τ, i, n)  # τ^i mod n
    S1_i = tau_power_i * P      # τ^i ⋅ P
    S1.append(S1_i)

print(f"S1 computed: {len(S1)} points")

# Define the Fibonacci example polynomial a(x) from previous exercises
I = [1, 2, 3, 4]
a_values = {1: 0, 2: 1, 3: 1, 4: 3}  # Left input values from Fibonacci example
a = interpolate(I, list(a_values.values()))

print(f"\nFibonacci polynomial a(x): {a}")
print(f"Polynomial degree: {a.degree()}")

# Get coefficients of polynomial a(x)
a_coeffs = a.coefficients(sparse=False)
print(f"Polynomial coefficients: {a_coeffs}")

# Implement the commitment function
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

# Test the commitment function on polynomial a(x)
print("\n=== Testing Commitment Function ===")
c = commitment(S1, a)
print(f"Commitment c = {c}")

# Verify the commitment is correct by computing p(τ)⋅P directly
print("\n=== Verification ===")
a_at_tau = a(τ)  # Evaluate a(x) at τ
expected_c = Integer(a_at_tau) * P  # p(τ)⋅P
print(f"a(τ) = {a_at_tau}")
print(f"Expected commitment a(τ)⋅P = {expected_c}")
print(f"Commitment matches: {c == expected_c}")

# Additional verification: check individual terms
print("\n=== Detailed Verification ===")
coeffs = a.coefficients(sparse=False)
print("Commitment computation breakdown:")
manual_c = S1[0] * 0  # Start with point at infinity
for i in range(len(coeffs)):
    ai = Integer(coeffs[i])
    term = ai * S1[i]
    manual_c = manual_c + term
    print(f"  a{i} * S1[{i}] = {ai} * S1[{i}] = {term}")

print(f"Manual computation result: {manual_c}")
print(f"Function result matches manual: {c == manual_c}")

print("\n=== Summary ===")
print("✓ Commitment function implemented successfully")
print("✓ Tested on Fibonacci polynomial a(x)")
print("✓ Verification shows c = a(τ)⋅P")
print("✓ The commitment can now be sent to the verifier")
print("✓ Later, the prover can provide evaluation proofs for any challenge γ")