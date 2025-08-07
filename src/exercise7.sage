# Exercise 7: KZG Polynomial Commitment Scheme 
# Link : https://plonk.zksecurity.xyz/2_Schwartz-Zippel_Zero-Testing_and_Commitments/4_KZG_polynomial_commitment_scheme.html

# Load elliptic curve setup from exercise6
# BN254 curve parameters
q = 21888242871839275222246405745257275088696311157297823662689037894645226208583
n = Integer(21888242871839275222246405745257275088548364400416034343698204186575808495617)
k = 12
t = 6*pow(4965661367192848881,2)+1

# Define the base field
Fq = GF(q)

# Define BN254 elliptic curve: y^2 = x^3 + 3
E = EllipticCurve(Fq, [0, 3])

# Generator points for G1 and G2
# G1 generator (on base curve)
P_x = 1
P_y = 2
P = E(P_x, P_y)

# For G2, we need the twist curve over Fq^2
# BN254 uses a sextic twist
Fq2.<i> = GF(q^2, modulus=x^2+1)
E2 = EllipticCurve(Fq2, [0, 3/(i+9)])

# G2 generator coordinates (these are standard BN254 G2 generator coordinates)
Q_x0 = 10857046999023057135944570762232829481370756359578518086990519993285655852781
Q_x1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634
Q_y0 = 8495653923123431417604973247489272438418190587263600148770280649306958101930
Q_y1 = 4082367875863433681332203403145435568316851327593401208105741076214120093531

Q_x = Fq2([Q_x0, Q_x1])
Q_y = Fq2([Q_y0, Q_y1])
Q = E2(Q_x, Q_y)

print(f"P (G1 generator): {P}")
print(f"Q (G2 generator): {Q}")

# KZG Trusted Setup Parameters
τ = 424242  # Toxic waste (must be deleted after setup)
l = 10      # Maximum polynomial degree

print(f"\n=== KZG Trusted Setup ===")
print(f"Toxic waste τ: {τ}")
print(f"Maximum polynomial degree l: {l}")

# Compute S1 = [P, τ⋅P, τ²⋅P, ..., τˡ⋅P]
print(f"\nComputing S1 = [P, τ⋅P, τ²⋅P, ..., τˡ⋅P]...")
S1 = []
for i in range(l + 1):
    tau_power_i = pow(τ, i, n)  # τ^i mod n
    S1_i = tau_power_i * P      # τ^i ⋅ P
    S1.append(S1_i)
    print(f"S1[{i}] = τ^{i} ⋅ P = {S1_i}")

# Compute S2 = τ⋅Q
print(f"\nComputing S2 = τ⋅Q...")
S2 = τ * Q
print(f"S2 = τ⋅Q = {S2}")

print(f"\n=== Verification ===")
print(f"S1 length: {len(S1)} (should be {l+1})")
print(f"S1[0] = P: {S1[0] == P}")
print(f"S1[1] = τ⋅P: {S1[1] == τ * P}")
print(f"S2 = τ⋅Q: {S2 == τ * Q}")

print(f"\n=== Final Results ===")
print(f"S1 = {S1}")
print(f"S2 = {S2}")

print(f"\n=== KZG Setup Summary ===")
print(f"The trusted setup has generated:")
print(f"- S1: A vector of {l+1} G1 points [P, τP, τ²P, ..., τˡP]")
print(f"- S2: A single G2 point τQ")
print(f"- These parameters enable polynomial commitments up to degree {l}")
print(f"- The toxic waste τ = {τ} must now be securely deleted!")