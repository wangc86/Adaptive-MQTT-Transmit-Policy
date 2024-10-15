import random
import matplotlib.pyplot as plt
import numpy as np

normal = True
trace_length = 5100
#congestion_count = 30

for i in range(0, trace_length):
	if normal:
		burst = 0
		length = 0
		prob = random.uniform(0,100)
		#if prob < 5 and congestion_count > 0:
		#if prob < 5:
		if prob < 10:
		#if True:
#			congestion_count -= 1
			normal = False
			#burst = random.uniform(3,5)
			burst = random.expovariate(0.3)
			length = int(random.uniform(10,25))
#	else:
#		burst = random.uniform(2,4)

	print("%f, " % (random.uniform(0.15,0.45)+burst), end='')
	if length > 0:
		length -= 1
		if length == 0:
			normal = True

#	if i % 5 == 4:
#		print("")

print("0.3")
 
