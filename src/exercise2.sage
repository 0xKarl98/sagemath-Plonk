"""Exercise2 Link : 
https://plonk.zksecurity.xyz/1_Getting_started/3_A_constraint_system.html
"""

# Variable definitions from exercise1
I = [1,2,3,4]
LI = {1:0,2:1,3:1,4:3}
RI = {1:1,2:1,3:2,4:3}
O = {1:1,2:2,3:3,4:9}  # O should be a dictionary with correct values

#Constraint 1
assert LI[1]== 0 and RI[1]==1

#Constraint 2
for i in I:
    if i != 4:
        assert LI[i] + RI[i] == O[i]
#Constraint 3
"""
In plain words , it means:
For any i that not equal to 3 or 4 , we have the following equation holds :
LI(i+1) = RI(i) and RI(i+1) = O(i)
"""
for i in I: 
    if i != 3 and i != 4:
        assert LI[i+1] == RI[i] and RI[i+1] == O[i]

#Constraint 4
"""
In plain words , it means:
LI(4) = RI(4) = O(3) 

assert(LI[4] == RI[4] == O[3])
"""


#Constraint 5
"""
In plain words , it means:
LI(4) * RI(4) = O(4)
"""
assert(LI[4] * RI[4] == O[4])
