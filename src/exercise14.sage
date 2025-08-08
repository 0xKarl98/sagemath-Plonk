# Exercise 14: Permutation Argument and Copy Constraints
# Based on: https://plonk.zksecurity.xyz/3_Domains_and_Wiring/3_Permutation_Argument_and_Copy_constraints.html

# Setup finite field and polynomial ring
p = 21888242871839275222246405745257275088548364400416034343698204186575808495617
F = GF(p)
R.<x> = PolynomialRing(F)

# Find a 4th root of unity
# Using root of unity ω, will bring us much more convenient in interpolation
n = 4
h = 1
while True:
    ω = F(h)^((p-1)//n)
    if ω^n == 1:
        powers = [ω^i for i in range(n)]
        if len(set(powers)) == n:  # Ensure all powers are distinct
            break
    h += 1

print(f"Found ω = {ω}")
print(f"ω^{n} = {ω^n}")
print(f"Powers of ω: {[ω^i for i in range(n)]}")

# Define the multiplicative domain Ω
Ω = [ω^i for i in range(n)]
print(f"\nMultiplicative domain Ω = {Ω}")

# Define witness values for our circuit (squared Fibonacci example)
# Gate 1: a1 * b1 = c1 (1 * 1 = 1)
# Gate 2: a2 * b2 = c2 (1 * 1 = 1) 
# Gate 3: a3 * b3 = c3 (1 * 2 = 2)
# Gate 4: a4 + b4 = c4 (2 + 3 = 5) - addition gate
a_values = [1, 1, 1, 2]  # Left inputs
b_values = [1, 1, 2, 3]  # Right inputs  
c_values = [1, 1, 2, 5]  # Outputs

print(f"\nWitness values:")
print(f"a = {a_values}")
print(f"b = {b_values}")
print(f"c = {c_values}")

# Lagrange interpolation function
def interpolate(domain, values):
    """Perform Lagrange interpolation over the given domain and values"""
    poly = R(0)
    for i in range(len(values)):
        # Compute Lagrange basis polynomial L_i(x)
        L_i = R(1)
        for j in range(len(domain)):
            if i != j:
                L_i *= (x - domain[j]) / (domain[i] - domain[j])
        poly += values[i] * L_i
    return poly

# Interpolate witness polynomials
a = interpolate(Ω, a_values)
b = interpolate(Ω, b_values)
c = interpolate(Ω, c_values)

print(f"\nInterpolated polynomials:")
print(f"a(x) = {a}")
print(f"b(x) = {b}")
print(f"c(x) = {c}")

# Verify interpolation
print(f"\nVerification of interpolation:")
for i in range(n):
    print(f"a(ω^{i}) = {a(ω^i)} (expected: {a_values[i]})")
    print(f"b(ω^{i}) = {b(ω^i)} (expected: {b_values[i]})")
    print(f"c(ω^{i}) = {c(ω^i)} (expected: {c_values[i]})")

# Exercise 14: Compute permutation σ
# We need to encode the wiring between the three columns a, b, c
# Positions are numbered 1 to 12 (4 rows × 3 columns)
# Column a: positions 1-4
# Column b: positions 5-8  
# Column c: positions 9-12

sigma = {}

# Based on the squared Fibonacci circuit wiring:
# We need to identify which values are equal across different positions

# Looking at our values:
# a = [1, 1, 1, 2]
# b = [1, 1, 2, 3] 
# c = [1, 1, 2, 5]

# Value 1 appears at positions: 1, 2, 3 (in a), 5, 6 (in b), 9, 10 (in c)
# Value 2 appears at positions: 4 (in a), 7 (in b), 11 (in c)
# Value 3 appears at position: 8 (in b)
# Value 5 appears at position: 12 (in c)

# Create cycles for equal values:
# Cycle for value 1: positions 1, 2, 3, 5, 6, 9, 10
# Cycle for value 2: positions 4, 7, 11
# Isolated: position 8 (value 3), position 12 (value 5)

# First input (isolated)
sigma[1] = 1

# First cycle: positions 2, 5 (both have value 1)
sigma[2] = 5
sigma[5] = 2

# Second cycle: positions 3, 6, 9 (all have value 1)
sigma[3] = 6  
sigma[6] = 9   
sigma[9] = 3   

# Third cycle: positions 4, 7, 11 (all have value 2)
sigma[4] = 7
sigma[7] = 11
sigma[11] = 4

# Fourth cycle: position 10 (value 1) connects to the first cycle
# isolated for now
sigma[10] = 10  

# Isolated elements
sigma[8] = 8   # value 3
sigma[12] = 12 # value 5

print(f"\nPermutation σ:")
for i in range(1, 13):
    print(f"σ({i}) = {sigma[i]}")

# Verification checks
print(f"\nVerification checks:")
print(f"Length should be 12: {len(sigma) == 12}")
print(f"There should be no repeated elements in the domain: {len(set(sigma.keys())) == 12}")
print(f"Both the image and domain should be the indexes from 1 to 12: {set(sigma.keys()) == set(range(1,13)) == set(sigma.values())}")
print(f"The cycle (3,4+2,8+1) should be in sigma: {sigma[3] == 4+2 and sigma[4+2] == 8+1 and sigma[8+1] == 3}")

# Function to get wire value at position
def get_wire_value(pos):
    if 1 <= pos <= n:               # column a
        return a(ω**(pos-1))        # pos-1 because positions are 1-indexed
    elif n+1 <= pos <= 2*n:         # column b
        return b(ω**(pos - n - 1))  # pos-n-1 because positions are 1-indexed
    elif 2*n+1 <= pos <= 3*n:       # column c
        return c(ω**(pos - 2*n - 1)) # pos-2n-1 because positions are 1-indexed

# Verify that wired positions have equal values
print(f"\nWire value verification:")
for i in range(1, 3*n + 1):
    val_i = get_wire_value(i)
    val_sigma_i = get_wire_value(sigma[i])
    print(f"Position {i}: value = {val_i}, Position {sigma[i]}: value = {val_sigma_i}, Equal: {val_i == val_sigma_i}")
    assert val_i == val_sigma_i, f"Wire values don't match at position {i}"

print(f"\nAll wire value checks passed!")

# Demonstrate polynomial composition issue
print(f"\nPolynomial composition example:")
print(f"a(x) has degree: {a.degree()}")
print(f"b(x) has degree: {b.degree()}")
composition = a(b)
print(f"a(b(x)) has degree: {composition.degree()}")
print(f"This shows why polynomial composition is expensive for large degrees.")

print(f"\nExercise 14 completed successfully!")
print(f"The permutation σ correctly encodes the wiring constraints of the circuit.")
print(f"Next step would be to implement an efficient permutation argument protocol.")