# Import necessary definitions from previous exercises
p = 21888242871839275222246405745257275088548364400416034343698204186575808495617
F = GF(p)
R.<x> = PolynomialRing(F, 'x')

# Define interpolation function
def interpolate(I, Y):
    n = len(I)
    f = 0
    for j in range(n):
        L_j = 1
        for i in range(n):
            if i != j:
                L_j *= (x - I[i]) / (I[j] - I[i])
        f += Y[j] * L_j
    return f

# Variable definitions from previous exercises
I = [1,2,3,4]
a = {1:0,2:1,3:1,4:3}  # Left input values
b = {1:1,2:1,3:2,4:3}  # Right input values
c = {1:1,2:2,3:3,4:9}  # Output values

# Selector polynomials
SL = {1:1,2:1,3:1,4:0}
SR = {1:1,2:1,3:1,4:0}
SM = {1:0,2:0,3:0,4:1}

qL = interpolate(I, list(SL.values()))
qR = interpolate(I, list(SR.values()))
qM = interpolate(I, list(SM.values()))

# Interpolate input/output polynomials
a_poly = interpolate(I, list(a.values()))
b_poly = interpolate(I, list(b.values()))
c_poly = interpolate(I, list(c.values()))

# Define constraint polynomial t(x) = qL(x)*a(x) + qR(x)*b(x) + qM(x)*a(x)*b(x) - c(x)
t = qL * a_poly + qR * b_poly + qM * a_poly * b_poly - c_poly

# Define recursive constraint polynomials f1 and f2
# f1: For i in {1,2}: a(i+1) = b(i) 
# f2: For i in {1,2}: b(i+1) = c(i)
f1_values = []
f2_values = []
for i in I:
    if i <= 2:  # For i in {1,2}
        f1_values.append(a[i+1] - b[i])  # a(i+1) - b(i) should be 0
        f2_values.append(b[i+1] - c[i])  # b(i+1) - c(i) should be 0
    else:
        f1_values.append(0)  # No constraint for i=3,4
        f2_values.append(0)  # No constraint for i=3,4

f1 = interpolate(I, f1_values)
f2 = interpolate(I, f2_values)

# Compute vanishing polynomial Z(x) = ∏(x - i) for i in I
Z = R(1)  # Start with the constant polynomial 1
for i in I:
    Z *= (x - i)

# Compute quotient polynomial Q(x) such that t(x) = Q(x) * Z(x)
Q = t // Z

# Compute Z1(x) for I' = I \ {3,4} = {1,2}
I_prime = [1, 2]
Z1 = R(1)
for i in I_prime:
    Z1 *= (x - i)

# Compute quotient polynomials Q1(x) and Q2(x)
Q1 = f1 // Z1
Q2 = f2 // Z1

# Verification as shown in the PLONK tutorial
print("=== Verification Results ===")
print("Is t(x) = Q(x) * Z(x)?", t == Q*Z)
show("Q=", Q)
print("Is f1(x) = Q1(x) * Z1(x)?", f1 == Q1*Z1)
show("Q1=", Q1)
print("Is f2(x) = Q2(x) * Z1(x)?", f2 == Q2*Z1)
show("Q2=", Q2)