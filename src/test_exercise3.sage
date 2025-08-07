load('exercise3.sage')

print('qL =', qL)
print('qR =', qR) 
print('qM =', qM)
print('\nTesting qL interpolation:')
for i in I:
    print('qL(' + str(i) + ') =', qL(i))

print('\nTesting qR interpolation:')
for i in I:
    print('qR(' + str(i) + ') =', qR(i))

print('\nTesting qM interpolation:')
for i in I:
    print('qM(' + str(i) + ') =', qM(i))