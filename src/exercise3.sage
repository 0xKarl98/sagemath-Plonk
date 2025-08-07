"""
Exercise3 Link : 
https://plonk.zksecurity.xyz/1_Getting_started/4_Selectors_and_Interpolation.html
"""

def interpolate(I, Y):
    """
    Given two lists I and Y of the same length n:
      I = [x1, x2, ..., x_n]
      Y = [y1, y2, ..., y_n]
    where all x_i are distinct, return the Lagrange interpolation polynomial f(x)
    such that f(x_i) = y_i for each i.
    """    
    # Implement Lagrange interpolation formula following PLONK tutorial
    # f(x) = sum_j(y_j * product_i((x - x_i)/(x_j - x_i))) for i != j
    n = len(I)
    f = 0
    
    for j in range(n):
        # Compute Lagrange basis function for j-th point
        L_j = 1
        for i in range(n):
            if i != j:
                L_j *= (x - I[i]) / (I[j] - I[i])
        
        # Accumulate to interpolation polynomial
        f += Y[j] * L_j
    
    return f

p = 21888242871839275222246405745257275088548364400416034343698204186575808495617
F = GF(p)
R.<x> = PolynomialRing(F, 'x')   


SL= {1:1,2:1,3:1,4:0} #Similar as before, we use dictionaries to map 1..4 to selectors for each gate
SR= {1:1,2:1,3:1,4:0}  # Choose the right selector as the same of SL too
SM = {1:0,2:0,3:0,4:1}  # Multiplication selector, only gate 4 is a multiplication gate

# Define index list I first
I = [1,2,3,4]

qL = interpolate(I,list(SL.values())) # Interpolation polynomial for left input selector
qR = interpolate(I,list(SR.values())) # Interpolation polynomial for right input selector
qM = interpolate(I,list(SM.values())) # Interpolation polynomial for multiplication selector

# Variable definitions from previous exercises
a = {1:0,2:1,3:1,4:3}  # Left input values
b = {1:1,2:1,3:2,4:3}  # Right input values
c = {1:1,2:2,3:3,4:9}  # Output values