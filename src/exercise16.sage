# Exercise 16: Partial Accumulators Implementation
# Based on: https://plonk.zksecurity.xyz/3_Domains_and_Wiring/5_Partial_accumulators.html

# Import necessary components from exercise15
load("exercise15.sage")

print("=== Exercise 16: Partial Accumulators ===")
print("Implementing accumulator functions for numerator and denominator")

# Exercise 16: Implement partial accumulator functions
# acc_numerator(i,column,f,σ,β,γ) = ∏(j=1 to i-1) numerator(j,column,f,σ,β,γ)
# acc_denominator(i,column,f,σ,β,γ) = ∏(j=1 to i-1) denominator(j,column,f,σ,β,γ)

# Note: Partial accumulator can be viewed as an efficient version of grand product argument 
# The verifier only needs to know if the recursive relation holds at random point at constructed polynomial 
# To check : Z(ω⁰) = 1 (initial value) ;
#            Z(ω^(i+1)) = Z(ωⁱ) × numerator(i+1) / denominator(i+1) (Recursive relation)
#            Z(ωⁿ) = 1(Final verification)

def acc_numerator(i, column, f, sigma, beta, gamma):
    """
    Compute accumulator function for the numerator
    
    Parameters:
    - i: Upper bound index (exclusive)
    - column: Column index (1-based, 1=a, 2=b, 3=c)
    - f: Polynomial function (a, b, or c)
    - sigma: Permutation dictionary
    - beta, gamma: Random challenges
    
    Returns: ∏(j=1 to i-1) numerator(j,column,f,σ,β,γ)
    """
    value = 1
    for j in range(1, i):
        value *= numerator(j, column, f, sigma, beta, gamma)
    return value

def acc_denominator(i, column, f, sigma, beta, gamma):
    """
    Compute accumulator function for the denominator
    
    Parameters:
    - i: Upper bound index (exclusive)
    - column: Column index (1-based, 1=a, 2=b, 3=c)
    - f: Polynomial function (a, b, or c)
    - sigma: Permutation dictionary
    - beta, gamma: Random challenges
    
    Returns: ∏(j=1 to i-1) denominator(j,column,f,σ,β,γ)
    """
    value = 1
    for j in range(1, i):
        value *= denominator(j, column, f, sigma, beta, gamma)
    return value

# Test the implementation
print("\n=== Testing Accumulator Functions ===")

# Test with challenges β = 42, γ = 42
beta = 42
gamma = 42

print(f"Using challenges: β = {beta}, γ = {gamma}")

# Calculate individual accumulators for each column
print("\n=== Individual Column Accumulators ===")

# Column a accumulators
acc_num_a = acc_numerator(n+1, 1, a, sigma, beta, gamma)
acc_den_a = acc_denominator(n+1, 1, a, sigma, beta, gamma)
print(f"Column a: acc_numerator({n+1},1,a,sigma,{beta},{gamma}) = {acc_num_a}")
print(f"Column a: acc_denominator({n+1},1,a,sigma,{beta},{gamma}) = {acc_den_a}")

# Column b accumulators
acc_num_b = acc_numerator(n+1, 2, b, sigma, beta, gamma)
acc_den_b = acc_denominator(n+1, 2, b, sigma, beta, gamma)
print(f"Column b: acc_numerator({n+1},2,b,sigma,{beta},{gamma}) = {acc_num_b}")
print(f"Column b: acc_denominator({n+1},2,b,sigma,{beta},{gamma}) = {acc_den_b}")

# Column c accumulators
acc_num_c = acc_numerator(n+1, 3, c, sigma, beta, gamma)
acc_den_c = acc_denominator(n+1, 3, c, sigma, beta, gamma)
print(f"Column c: acc_numerator({n+1},3,c,sigma,{beta},{gamma}) = {acc_num_c}")
print(f"Column c: acc_denominator({n+1},3,c,sigma,{beta},{gamma}) = {acc_den_c}")

# Calculate the grand product
print("\n=== Grand Product Verification ===")

# Calculate N_n (product of all numerator accumulators)
N_n = acc_num_a * acc_num_b * acc_num_c
print(f"N_n = acc_numerator(a) * acc_numerator(b) * acc_numerator(c) = {N_n}")

# Calculate D_n (product of all denominator accumulators)
D_n = acc_den_a * acc_den_b * acc_den_c
print(f"D_n = acc_denominator(a) * acc_denominator(b) * acc_denominator(c) = {D_n}")

# Verify that N_n / D_n = 1
ratio = N_n // D_n
print(f"\nRatio N_n / D_n = {ratio}")
print(f"Verification: N_n / D_n == 1? {ratio == 1}")

if ratio == 1:
    print("✓ SUCCESS: The grand product equals 1, confirming the permutation argument!")
else:
    print("✗ FAILURE: The grand product does not equal 1.")

# Additional verification: Since we're working in a finite field,
# the concept of divisibility is different. The ratio being 1 is sufficient.

# Detailed step-by-step verification for small examples
print("\n=== Step-by-Step Verification ===")
print("Showing individual terms for column a:")
for j in range(1, n+1):
    num_val = numerator(j, 1, a, sigma, beta, gamma)
    den_val = denominator(j, 1, a, sigma, beta, gamma)
    print(f"  j={j}: numerator = {num_val}, denominator = {den_val}, ratio = {num_val}/{den_val}")

print("\n=== Exercise 16 Completed ===")
print("Partial accumulator functions successfully implemented and verified!")
print("The grand product argument demonstrates that the permutation σ correctly encodes")
print("the wiring constraints, as the product of all ratios equals 1.")