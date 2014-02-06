from pprint import pprint
import numpy as np
import cProfile

def normalize(matrix,factor=5):
	"""
	This function does x - meu/std normalization, and multiples by a factor
	and then rounds to get an integer. 
	"""
	returnMatrix = []
	for row in matrix:
		avg = np.average(row)
		std = np.std(row)
		normalized = []
		for col in row:
			normalized.append(int((col - avg)/std * factor))
		returnMatrix.append(normalized)
	return returnMatrix

def openCSV(filename,header=False):
	"""
	Opens up a CSV in the local directory and returns (nested) lists.
	"""
	toReturn = []
	with open(filename,"r") as f:
		for elem in f:
			toReturn.append(f.readline().split(","))

def parseSingleData(data,normalize=False,binary=False):
	"""
	Returns a cost matrix derived from a single matrix where
	each row is compared against the others for similarity, or really, differences.

	When binary is true, we only check if they are the same. If they are not,
	the c[i][j] will be set as 0 (no relation). Otherwise, it will be a positive
	value that measures the difference in scores.

	Note that the rows is always the people, consequently we make all matrices
	to be an M by M matrix, where M is the number of rows, or len(data).
	"""
	if(normalize):
		data = normalize(data)
	m = len(data)
	#Creating the cost matrix
	c = [[0 for x in range(m)] for y in range(m)]
	if(binary):
		#Checking for "binary" difference
		for person in range(m):
			for other in range(m):
				c[person][other] = len(filter(lambda x: x == 0,[data[person][i] - data[other][i] for i in data[person]]))
		pprint(c)
		return c
	else:
		#Checking for "relational" difference
		for person in range(m):
			for other in range(m):
				c[person][other] = abs(raw[person][0] - raw[other][0]) + abs(raw[person][1] - raw[other][1])
		pprint(c)
		return c

def parseMultipleData(current,desired,norm=True):
	"""
	Meant for creating a cost matrix from a 'current attributes' against a
	'desired attributes' matrix. Very specific.
	"""
	if(norm):
		C = np.matrix(normalize(current))
		D = np.matrix(normalize(desired))	
	c = C*D.transpose()
	c = [x for x in c.tolist()]
	#I'm adding in this diagonal for the self-matching constraint.
	m = len(c)
	for i in range(m):
		c[i][i] = -1337	#Magic number.
	pprint(c)
	return c

#Input parameters here
desired = [[0,10,0,0,0,10,0,5,5,0],
			[4,2,1,10,6,5,7,8,9,3],
			[8,6,4,7,5,4,1,3,6,7],
			[5,6,4,2,1,8,1,3,8,7],
			[10,10,2,3,2,5,3,2,8,6],
			[5,5,9,7,9,9,10,10,10,5],
			[7,2,9,0,1,10,3,7,10,7],
			[0,0,0,0,0,10,0,0,0,0],
			[7,4,8,5,8,10,3,8,7,8]]

current = [[0,1,9,7,8,5,2,6,9,9],
			[7,6,3,5,4,8,9,2,1,10],
			[1,1,4,6,4,8,1,3,4,5],
			[8,8,2,3,3,4,0,0,7,4],
			[7,10,0,0,0,0,1,0,3,0],
			[0,0,5,3,2,1,4,8,5,3],
			[0,0,3,0,3,6,0,4,5,3],
			[0,0,7,5,3,6,2,0,0,7],
			[4,2,5,8,8,8,2,5,5,7]]

food = [[2,4,7],
[1,2,6],
[2,7,8],
[2,3,7],
[1,4,7],
[3,5,7],
[2,4,7],
[1,2,8]]

raw = [[16,10],
		[14,9],
		[14,10],
		[12,10],
		[15,13],
		[9,11],
		[10,16],
		[16,10]]

names = ["Nick", "Gaithersburg", "Wichita", "Rishon", "LA", "Jerusalem", "Walla Walla", "Mike","Amherst"]
numPartners = 1
c = parseMultipleData(current,desired,norm=True)
m = len(c)
n = len(c[0])


#Initialize
p = MixedIntegerLinearProgram(maximization=True, solver = "GLPK")


#Creating the variable matrix
x = p.new_variable(binary = True,dim=2,name="Persons")


#Adding row and column constraints (sum of row and column must equal numPartners)
#Also people can't be paired with themselves (third one) unless odd number of people.
for i in range(m):
	p.add_constraint(sum([x[i][j] for j in range(m)]) == numPartners)
	p.add_constraint(sum([x[j][i] for j in range(m)]) == numPartners)

#Partnering with self constraint
#If uneven number of people, at most there can be num parters - 1 partnered with themselves.
p.add_constraint(sum([x[i][i] for i in range(m)]) <= (numPartners - 1) * -1337)


#Constraint such that the table must be symmetric
#NOT USEFUL FOR NUMPARTERS > 1
for i in range(m):
	for j in range(m):
		#p.add_constraint(x[i][j] == x[j][i])
		pass	

#Constraint for a floor of satisfiability
#THIS ADDS A LOT OF TIME TO COMPUTATION
for i in range(m):
	#p.add_constraint(sum([c[i][j] * x[i][j] for j in range(m)]) >= min([f for f in c[i]]))
	pass


#Constraint that the size of the set of all groups is m/numPartners
#I have no idea how to do this. Partioning a graph into N complete graphs?

#for i in range(m):
#	for j in range(m):
#		p.add_constraint(print(x[i][j] * primes_first_n(m)))

#Objective function
p.set_objective(sum([x[i][j] * c[i][j] for i in range(m) for j in range(n)]))

#Printing results
#p.show()
print 'Objective Value:', p.solve()
for i, v in p.get_values(x).iteritems():
	print v.values()

for i, v in p.get_values(x).iteritems():
	partner = []
	for elem in v.keys():
		if v[elem] > 0:
			partner.append(names[elem])
	print names[i] + " = " + ", ".join(partner)