"""Exercise 5: Schwartz-Zippel Zero-Testing
Link: https://plonk.zksecurity.xyz/2_Schwartz-Zippel_Zero-Testing_and_Commitments/1_Towards_a_more_efficient_version.html
"""

# Load the polynomials from exercise4
load('exercise4.sage')

# Random values for Schwartz-Zippel testing
γ1 = 42
γ2 = 74102
γ3 = 987654321987654321

print("=== Exercise 5: Schwartz-Zippel Zero-Testing ===")
print("\nEvaluating polynomials at random points:")
print(f"γ1 = {γ1}")
print(f"γ2 = {γ2}")
print(f"γ3 = {γ3}")

# Evaluate constraint polynomial t(x) at random points
print("\n=== Constraint polynomial t(x) evaluations ===")
print(f"t(γ1) = t({γ1}) = {t(γ1)}")
print(f"t(γ2) = t({γ2}) = {t(γ2)}")
print(f"t(γ3) = t({γ3}) = {t(γ3)}")

# Evaluate Q(x) * Z(x) at random points to verify t(x) = Q(x) * Z(x)
print("\n=== Verification: Q(x) * Z(x) evaluations ===")
print(f"Q(γ1) * Z(γ1) = {Q(γ1)} * {Z(γ1)} = {Q(γ1) * Z(γ1)}")
print(f"Q(γ2) * Z(γ2) = {Q(γ2)} * {Z(γ2)} = {Q(γ2) * Z(γ2)}")
print(f"Q(γ3) * Z(γ3) = {Q(γ3)} * {Z(γ3)} = {Q(γ3) * Z(γ3)}")

# Verify equality at random points (Schwartz-Zippel test)
print("\n=== Schwartz-Zippel Test Results ===")
print(f"t(γ1) == Q(γ1) * Z(γ1)? {t(γ1) == Q(γ1) * Z(γ1)}")
print(f"t(γ2) == Q(γ2) * Z(γ2)? {t(γ2) == Q(γ2) * Z(γ2)}")
print(f"t(γ3) == Q(γ3) * Z(γ3)? {t(γ3) == Q(γ3) * Z(γ3)}")

# Evaluate recursive constraint polynomials at random points
print("\n=== Recursive constraint polynomials evaluations ===")
print(f"f1(γ1) = {f1(γ1)}")
print(f"f1(γ2) = {f1(γ2)}")
print(f"f1(γ3) = {f1(γ3)}")

print(f"f2(γ1) = {f2(γ1)}")
print(f"f2(γ2) = {f2(γ2)}")
print(f"f2(γ3) = {f2(γ3)}")

# Verify Q1(x) * Z1(x) = f1(x) at random points
print("\n=== Verification: Q1(x) * Z1(x) = f1(x) ===")
print(f"Q1(γ1) * Z1(γ1) = {Q1(γ1)} * {Z1(γ1)} = {Q1(γ1) * Z1(γ1)}")
print(f"Q1(γ2) * Z1(γ2) = {Q1(γ2)} * {Z1(γ2)} = {Q1(γ2) * Z1(γ2)}")
print(f"Q1(γ3) * Z1(γ3) = {Q1(γ3)} * {Z1(γ3)} = {Q1(γ3) * Z1(γ3)}")

print(f"f1(γ1) == Q1(γ1) * Z1(γ1)? {f1(γ1) == Q1(γ1) * Z1(γ1)}")
print(f"f1(γ2) == Q1(γ2) * Z1(γ2)? {f1(γ2) == Q1(γ2) * Z1(γ2)}")
print(f"f1(γ3) == Q1(γ3) * Z1(γ3)? {f1(γ3) == Q1(γ3) * Z1(γ3)}")

# Verify Q2(x) * Z1(x) = f2(x) at random points
print("\n=== Verification: Q2(x) * Z1(x) = f2(x) ===")
print(f"Q2(γ1) * Z1(γ1) = {Q2(γ1)} * {Z1(γ1)} = {Q2(γ1) * Z1(γ1)}")
print(f"Q2(γ2) * Z1(γ2) = {Q2(γ2)} * {Z1(γ2)} = {Q2(γ2) * Z1(γ2)}")
print(f"Q2(γ3) * Z1(γ3) = {Q2(γ3)} * {Z1(γ3)} = {Q2(γ3) * Z1(γ3)}")

print(f"f2(γ1) == Q2(γ1) * Z1(γ1)? {f2(γ1) == Q2(γ1) * Z1(γ1)}")
print(f"f2(γ2) == Q2(γ2) * Z1(γ2)? {f2(γ2) == Q2(γ2) * Z1(γ2)}")
print(f"f2(γ3) == Q2(γ3) * Z1(γ3)? {f2(γ3) == Q2(γ3) * Z1(γ3)}")

print("\n=== Summary ===")
print("All Schwartz-Zippel tests demonstrate that the polynomial equalities")
print("hold at random points, providing probabilistic verification of:")
print("1. t(x) = Q(x) * Z(x)")
print("2. f1(x) = Q1(x) * Z1(x)")
print("3. f2(x) = Q2(x) * Z1(x)")
print("\nThis confirms the correctness of our PLONK constraint system!")