# Exercise 11: Finding a Generator of a Multiplicative Domain
# This exercise finds a generator ω of a domain of order 4
# Reference: https://plonk.zksecurity.xyz/3_Domains_and_Wiring/1_Domains

# Define the prime field (using Python integers for modular arithmetic)
p = 21888242871839275222246405745257275088548364400416034343698204186575808495617

print("=== Exercise 11: Finding a Generator of a Multiplicative Domain ===")
print(f"Working in field F_p where p = {p}")
print("")
print("Goal: Find a generator ω of a domain of order 4")
print("Requirements:")
print("- ω^4 = 1 (ω is a 4th root of unity)")
print("- ω^i ≠ 1 for i ∈ {1, 2, 3} (ω has multiplicative order exactly 4)")
print("")

# Algorithm from the exercise:
# 1. Consider r = (p-1)/4
# 2. Find the smallest h ∈ F_p such that ω = h^r has multiplicative order 4

n = pow(2, 2)  # n = 4
print(f"Domain size n = {n}")

# Step 1: Calculate r = (p-1)/4
r = (p - 1) // 4
print(f"r = (p-1)/4 = {r}")
print("")

# Step 2: Find the smallest h such that ω = h^r has multiplicative order 4
print("Searching for the smallest h such that ω = h^r has multiplicative order 4...")

h = 1
while True:
    h += 1
    ω = pow(h, r, p)  # ω = h^r mod p
    
    # Check if ω has multiplicative order 4
    # This means ω^4 = 1 and ω^i ≠ 1 for i ∈ {1, 2, 3}
    
    ω_powers = []
    valid_generator = True
    
    for i in range(1, 5):  # Check powers 1, 2, 3, 4
        ω_i = pow(ω, i, p)
        ω_powers.append(ω_i)
        
        if i == 4:
            # ω^4 should equal 1
            if ω_i != 1:
                valid_generator = False
                break
        else:
            # ω^1, ω^2, ω^3 should not equal 1
            if ω_i == 1:
                valid_generator = False
                break
    
    if valid_generator:
        print(f"Found generator! h = {h}")
        print(f"ω = h^r = {h}^{r} ≡ {ω} (mod p)")
        break
    
    # Safety check to avoid infinite loop
    if h > 1000:
        print("Error: Could not find generator within reasonable range")
        break

print("")
print("=== Verification ===")
print(f"Generator ω = {ω}")
print("")
print("Powers of ω:")
for i in range(1, 5):
    ω_i = pow(ω, i, p)
    print(f"ω^{i} = {ω_i}")
    if i < 4:
        print(f"  ω^{i} ≠ 1: {ω_i != 1}")
    else:
        print(f"  ω^{i} = 1: {ω_i == 1}")

print("")
print("=== Domain Construction ===")
# Construct the multiplicative domain Ω = {ω^0, ω^1, ω^2, ω^3} = {1, ω, ω^2, ω^3}
Ω = []
for i in range(4):
    ω_i = pow(ω, i, p)
    Ω.append(ω_i)

print(f"Multiplicative domain Ω = {{ω^0, ω^1, ω^2, ω^3}}")
print(f"Ω = {Ω}")
print("")

# Verify that this is indeed a multiplicative subgroup of order 4
print("=== Subgroup Verification ===")
print("Checking closure under multiplication:")
for i in range(4):
    for j in range(4):
        product = (Ω[i] * Ω[j]) % p
        # Find which element of Ω this product corresponds to
        product_index = None
        for k in range(4):
            if Ω[k] == product:
                product_index = k
                break
        if product_index is not None:
            print(f"ω^{i} * ω^{j} = ω^{product_index} ✓")
        else:
            print(f"ω^{i} * ω^{j} = {product} (not in domain) ✗")

print("")
print("=== Vanishing Polynomial ===")
# The vanishing polynomial for this domain is Z(x) = x^4 - 1
print("Vanishing polynomial Z(x) = x^4 - 1")
print("This polynomial vanishes on all elements of the domain Ω")
print("")
print("Verification:")
for i, ω_i in enumerate(Ω):
    z_value = (pow(ω_i, 4, p) - 1) % p
    print(f"Z(ω^{i}) = (ω^{i})^4 - 1 = {z_value} (should be 0)")

print("")
print("=== Expected Result ===")
expected_ω = 21888242871839275217838484774961031246007050428528088939761107053157389710902
print(f"Expected ω = {expected_ω}")
print(f"Our result ω = {ω}")
print(f"Results match: {ω == expected_ω}")

if ω == expected_ω:
    print("✓ Correct! Found the expected generator.")
else:
    print("⚠ Different result, but still valid if it satisfies the conditions.")
    # Let's verify our result is still correct
    print("\nVerifying our result:")
    for i in range(1, 5):
        power = pow(ω, i, p)
        if i == 4:
            print(f"ω^{i} = {power} (should be 1): {power == 1}")
        else:
            print(f"ω^{i} = {power} (should not be 1): {power != 1}")

print("")
print("=== Summary ===")
print(f"✓ Found generator ω = {ω}")
print(f"✓ Domain size n = {n}")
print(f"✓ Multiplicative order of ω is exactly {n}")
print(f"✓ Domain Ω = {{1, ω, ω^2, ω^3}} constructed")
print(f"✓ Vanishing polynomial Z(x) = x^{n} - 1")
print("✓ This domain can be used for efficient polynomial operations in PLONK")

print("")
print("=== Implementation Notes ===")
print("1. Multiplicative domains provide constant-time vanishing polynomial computation")
print("2. The 'wrap around' property (ω^n = ω^0 = 1) is useful for wiring constraints")
print("3. Domains of size 2^k are particularly efficient for FFT operations")
print("4. This forms the foundation for more complex PLONK constraint systems")

print("")
print("✓ Exercise 11 completed: Multiplicative Domain Generator Found")

# Store results for potential use in other exercises
print("")
print("=== Results for Future Use ===")
print(f"n = {n}")
print(f"r = {r}")
print(f"h = {h}")
print(f"ω = {ω}")
print(f"Domain Ω = {Ω}")

# Additional verification: Check that we found a primitive 4th root of unity
print("")
print("=== Mathematical Verification ===")
print("Checking that ω is a primitive 4th root of unity:")
print(f"ω^1 mod p = {pow(ω, 1, p)}")
print(f"ω^2 mod p = {pow(ω, 2, p)}")
print(f"ω^3 mod p = {pow(ω, 3, p)}")
print(f"ω^4 mod p = {pow(ω, 4, p)} (should be 1)")

# Verify the algorithm worked correctly
print("")
print("=== Algorithm Verification ===")
print(f"Used algorithm: ω = h^r where r = (p-1)/4")
print(f"h = {h}, r = {r}")
print(f"ω = {h}^{r} mod {p} = {ω}")
print(f"Verification: {h}^{r} mod {p} = {pow(h, r, p)}")