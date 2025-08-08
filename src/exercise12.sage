# Exercise 12 & 13: Interpolation and Zero-Testing over Multiplicative Domains
# Based on: https://plonk.zksecurity.xyz/3_Domains_and_Wiring/2_Interpolation_and_Zero-Testing_over_domains.html

# Define the prime field (BN254 curve order)
p = 21888242871839275222246405745257275088548364400416034343698204186575808495617
F = GF(p)

# Define polynomial ring
R.<x> = PolynomialRing(F)

# Parameters
n = 4  # Domain size

# Find the 4th root of unity ω
r = (p - 1) // n
h = 2
while True:
    ω = F(h)^r
    powers = [ω^i for i in range(n)]
    if len(set(powers)) == n and ω^n == 1:
        break
    h += 1

print(f"Found ω = {ω}")
print(f"Verification: ω^{n} = {ω^n}")

# Define the multiplicative domain Ω = {ω^0, ω^1, ω^2, ω^3} = {1, ω, ω², ω³}
Ω = [ω^i for i in range(0, n)]
print(f"Multiplicative domain Ω = {Ω}")

# Define the witness values (from previous exercises)
# Left input (LI), Right input (RI), Output (O)
LI = {1: 3, 2: 4, 3: 5, 4: 5}  # a values
RI = {1: 4, 2: 5, 3: 6, 4: 6} # b values  
O = {1: 12, 2: 20, 3: 30, 4: 11} # c values (5+6=11 for addition gate)

# Define selector vectors for gates
# qL, qR, qM for different gate types
qL_vals = {1: 0, 2: 0, 3: 0, 4: 1}  # Addition gate at position 4
qR_vals = {1: 0, 2: 0, 3: 0, 4: 1}  # Addition gate at position 4
qM_vals = {1: 1, 2: 1, 3: 1, 4: 0}  # Multiplication gates at positions 1,2,3

print("\n=== Witness and Selector Values ===")
print(f"LI (a): {LI}")
print(f"RI (b): {RI}")
print(f"O (c): {O}")
print(f"qL: {qL_vals}")
print(f"qR: {qR_vals}")
print(f"qM: {qM_vals}")

# Lagrange interpolation function
def interpolate(domain, values):
    """
    Lagrange interpolation over given domain
    domain: list of x-coordinates
    values: list of y-coordinates
    """
    n = len(domain)
    result = R(0)
    
    for i in range(n):
        # Compute Lagrange basis polynomial L_i(x)
        L_i = R(1)
        for j in range(n):
            if i != j:
                L_i *= (x - domain[j]) / (domain[i] - domain[j])
        
        # Add contribution of this basis polynomial
        result += values[i] * L_i
    
    return result

print("\n=== Exercise 12: Interpolation over Multiplicative Domain ===")

# Exercise 12: Interpolate the value vectors and selector vectors over Ω
Ω_points = [ω^i for i in range(0, n)]  # {ω^0, ω^1, ω^2, ω^3}
a_values = [LI[i] for i in range(1, n+1)]  # Values at positions 1,2,3,4
b_values = [RI[i] for i in range(1, n+1)]
c_values = [O[i] for i in range(1, n+1)]
qL_values = [qL_vals[i] for i in range(1, n+1)]
qR_values = [qR_vals[i] for i in range(1, n+1)]
qM_values = [qM_vals[i] for i in range(1, n+1)]

print(f"Interpolation points Ω: {Ω_points}")
print(f"a values: {a_values}")
print(f"b values: {b_values}")
print(f"c values: {c_values}")

# Interpolate polynomials
a = interpolate(Ω_points, a_values)
b = interpolate(Ω_points, b_values)
c = interpolate(Ω_points, c_values)
qL = interpolate(Ω_points, qL_values)
qR = interpolate(Ω_points, qR_values)
qM = interpolate(Ω_points, qM_values)

print("\n=== Interpolated Polynomials ===")
print(f"a(x) = {a}")
print(f"b(x) = {b}")
print(f"c(x) = {c}")
print(f"qL(x) = {qL}")
print(f"qR(x) = {qR}")
print(f"qM(x) = {qM}")

# Verify interpolation by evaluating at domain points
print("\n=== Verification of Interpolation ===")
for i, point in enumerate(Ω_points):
    print(f"At ω^{i+1} = {point}:")
    print(f"  a({point}) = {a(point)} (expected: {a_values[i]})")
    print(f"  b({point}) = {b(point)} (expected: {b_values[i]})")
    print(f"  c({point}) = {c(point)} (expected: {c_values[i]})")

print("\n=== Exercise 13: Zero-Testing with Vanishing Polynomial ===")

# Exercise 13: Polynomial long division with vanishing polynomial
# Define the constraint polynomial t(x) = qM*a*b + qL*a + qR*b - c
t = qM * a * b + qL * a + qR * b - c

print(f"Constraint polynomial t(x) = {t}")

# Define the vanishing polynomial Z(x) = x^n - 1 = x^4 - 1
Z = x^n - 1
print(f"Vanishing polynomial Z(x) = {Z}")

# Perform polynomial long division: t(x) = Q(x) * Z(x) + R(x)
Quo, Rem = t.quo_rem(Z)

print("\n=== Polynomial Division Results ===")
print(f"Quotient Q(x): {Quo}")
print(f"Remainder R(x): {Rem}")
print(f"Is remainder zero? {Rem == 0}")

# Verify the division
verification = Quo * Z + Rem
print(f"\nVerification: Q(x)*Z(x) + R(x) = {verification}")
print(f"Original t(x) = {t}")
print(f"Division correct: {verification == t}")

# Check that t(x) vanishes on the domain Ω
print("\n=== Verification: t(x) vanishes on Ω ===")
for i, point in enumerate(Ω_points):
    t_val = t(point)
    print(f"t(ω^{i+1}) = t({point}) = {t_val}")

# Since R(x) = 0, we have t(x) = Q(x) * Z(x)
# This means t(x) vanishes exactly on the roots of Z(x), which are the n-th roots of unity
print("\n=== Summary ===")
print(f"✓ Successfully interpolated witness and selector polynomials over multiplicative domain Ω")
print(f"✓ Constraint polynomial t(x) = qM*a*b + qL*a + qR*b - c")
print(f"✓ Vanishing polynomial Z(x) = x^{n} - 1")
print(f"✓ Division is exact: t(x) = Q(x) * Z(x) with remainder R(x) = {Rem}")
print(f"✓ This proves that the constraints are satisfied on the domain Ω")

# Additional insight: Why this works
print("\n=== Mathematical Insight ===")
print("The fact that t(x) = Q(x) * Z(x) (with zero remainder) means:")
print("1. t(x) vanishes exactly on the roots of Z(x) = x^4 - 1")
print("2. The roots of Z(x) are the 4th roots of unity: {1, ω, ω², ω³}")
print("3. This proves our circuit constraints are satisfied at all points in Ω")
print("4. The quotient Q(x) encodes the 'proof' that constraints hold")
print("5. Verifier only needs to check the division, not evaluate at each point")

# Show the advantage of multiplicative domains
print("\n=== Advantage of Multiplicative Domains ===")
print("Additive domain: Z(x) = (x-1)(x-2)(x-3)(x-4) - requires O(n) operations")
print("Multiplicative domain: Z(x) = x^4 - 1 - computable in constant time!")
print("This efficiency gain is crucial for scalable zero-knowledge proofs.")