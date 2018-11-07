#!/usr/bin/env python3
import csv 
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
with open('left.csv') as left_file:
   left = np.array([])
   csv_reader = csv.reader(left_file, delimiter=" ")
   for row in csv_reader:
      tuple = np.array([float(row[0]),float(row[1])])
      left = np.append(left,[tuple])
left = np.resize(left,(5,2))

print(left)
print("\n")
with open('right.csv') as right_file:
   right = np.array([])
   csv_reader = csv.reader(right_file, delimiter=" ")
   for row in csv_reader:
      tuple = np.array([float(row[0]),float(row[1])])
      right = np.append(right,[tuple])
right = np.resize(right,(5,2))


left_mean=np.mean(left, axis =0) 
right_mean=np.mean(right,axis=0)
print("\n")
print(left_mean)

left_ = np.transpose(left -left_mean)
right_= np.transpose(right -right_mean)
print("\n")
print(left_)

C= np.matmul(left_, np.transpose(right_))
U,E,V = np.linalg.svd(C.T, full_matrices=False)
print("\n U:")
print(U)

R = np.matmul(V, U)
print("\nR:")
print(R)

just_translation_T = left_mean-right_mean
just_translation_result = right + just_translation_T

print("\n translation_T:")
print(just_translation_T)

rotation_result = np.matmul(R,np.transpose(right)).T
print("\nresult:")
print(rotation_result)
print(rotation_result.shape)

rotation_result_mean = np.mean(rotation_result, axis=0)
rotation_T=left_mean-rotation_result_mean
#print("\nleft':")
#print(left_mean)
#
#print("\nright':")
#print(right_mean)
#
#print("\nT':")
#print(T)
#
#print("\nrotation_result':")
#print(rotation_result)
result = np.add(rotation_T.T, rotation_result)


#print("\nresult':")
#print(result)

def rmsd(A,B):
#	print("A:")
#	print(A)
#	print("B:")
#	print(B)
	A_B = A-B
#	print("A-B:")
#	print(A_B)
	squared = np.square(A_B)
#	print("squared:")	
#	print(squared)
	sum1 = np.sum(squared, axis=1)
#	print("sum1:")
#	print(sum1)
	sum2 = np.sum(sum1, axis=0)
#	print("sum2:")
#	print(sum2)
	return np.sqrt(sum2/A.shape[0])


print ('without transformation:',rmsd(left, right))
print ('with just translation:', rmsd(left, just_translation_result))
print ('after rotation + translation:',rmsd(left, result))


left_x=[]
left_y=[]
right_x=[]
right_y=[]
just_translation_result_x=[]
just_translation_result_y=[]
result_x=[]
result_y=[]
for i in range(0, len(left)):
	left_x.append(left[i][0])
	left_y.append(left[i][1])

	right_x.append(right[i][0])
	right_y.append(right[i][1])

	just_translation_result_x.append(just_translation_result[i][0])
	just_translation_result_y.append(just_translation_result[i][1])

	result_x.append(result[i][0])
	result_y.append(result[i][1])
#print(result_x)
a=plt.scatter(left_x,left_y, marker="x", color='blue')
b=plt.scatter(right_x,right_y, marker="x", color = 'red')
c=plt.scatter(just_translation_result_x, just_translation_result_y, marker="o", color= 'green')
d=plt.scatter(result_x, result_y, marker="o", color= 'm')
plt.legend((a,b,c,d),('Original Left Point Cloud','Original Right Point Cloud', 'Translated Right Point Cloud','Rotated and Translated Right Point Cloud'))
plt.xticks(np.arange(0,30,step=5))
plt.yticks(np.arange(0,30,step=5))
#ax = plt.axes()
#ax.xaxis.set_major_locator(ticker.MultipleLocator(5))
plt.show()
