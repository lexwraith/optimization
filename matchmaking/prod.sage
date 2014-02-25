"""
This shit was written by Mike Nguyen.

MIPS Solver

Step 1) Create a cost matrix.
		You can either write your own script to create a cost matrix given
			some set of data you pulled off of Wordpress or Excel.

		OR you can manually copy and paste it into the input variables below.

		But we know that hard coding variables and/or magic numbers is a no no,
			now don't we?

		Note that as the code stands today 2/24/2014, I have included how I
			generated the cost matrix. So that might not be valuable to you.

Step 2)	Add in the names list. Each index of the list is what defines what each
			index of the row AND column of the matrix is in terms of name.

		E.G.:

		if names[2] == "John"
		then row[2] == "John"
		and col[2] == "John"
		and matrix[2][2] would either be 0 or 1, and represents if john is
			paired with himself or not
		and costmatrix[2][2] would mean how happy john would be with himself
			or unhappy, depending on how you make the cost matrix.


Step 3) Adjust the solver
		Problems can be classified as either a MAXIMIZATION of utility problem
			OR a MINIMIZATION OF COST problem.
		
		A MAXIMIZATION problem is a problem where the cost matrix represents how happy
			someone would be with another person if paired, meaning it's not really a 
			"cost" matrix, it should really be called a "utility" matrix.
		
		A MINIMIZATION problem is the exact opposite of that, and this is where the
			aptly named cost matrix is appropriate.

		So it depends on how you generate your cost/utility matrix. Do you want the
			values to represent happiness, or unhappiness?

		At this point the solver will create a binary matrix called "x" that is 
			what holds the answers during the computation. Its end result is
			what the answer actually is.

Step 4) Adjust the constraints
		See below. Each constraint is different and "prunes" the search tree
			in finding the optimal solution. This requires some linear algebra
			knowledge, but basically, the comments should guide you on some
			of the common sense constraints you want to use.

Step 5) Run "sage" on this file.
		It will compile the sage file into a python file, and then execute
			it using python.

Step 6) Repeat the process and adjust as needed.

"""

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
#Snagging the number of rows here
m = len(c) 
#Snagging the number of columns here.
n = len(c[0]) 



#Initialize the solver and adjust here
#Adjust the maximization argument as needed. Leave it as GLPK.
#GLPK uses a very slow method (the slowest in fact) but it guarantees the best
#	solution.
p = MixedIntegerLinearProgram(maximization=True, solver = "GLPK")


#Creating the variable/answer matrix
#This is where your answers are stored (temporarily) until all possibilities
#	are examined.
x = p.new_variable(binary = True,dim=2,name="Persons")


#Adding row and column constraints (sum of row and column must equal numPartners)
#Also people can't be paired with themselves (third one) unless odd number of people.
#This means that the summation of any row or column in the answer matrix must equal
#	numpartners, meaning every person has exactly num partners as partners.
for i in range(m):
	p.add_constraint(sum([x[i][j] for j in range(m)]) == numPartners)
	p.add_constraint(sum([x[j][i] for j in range(m)]) == numPartners)

#Partnering with self constraint
#This constraint prevents people from partnering with themselves,
#	or at least, makes it extremely unlikely and not preferred.
#	-1337 is a magic number, you can adjust based off of the range of your
#	cost matrix.
#That being said, there are cases where they MUST be paired with themselves,
#	e.g. when you can't divide the group evenly, and this allows that to
#	happen, albeit at great cost (-1337) at the time of this writing.
p.add_constraint(sum([x[i][i] for i in range(m)]) <= (numPartners - 1) * -1337)


#Constraint such that the table must be symmetric
#This guarantees that everyone is recommended with someone else who is
#	recommended with them. You can safely ignore it, as I have commented it
#	out, but if you are dividing a group evenly into groups of 2, I would
# 	probably turn it back on.
#NOT USEFUL FOR NUMPARTERS > 1
for i in range(m):
	for j in range(m):
		#p.add_constraint(x[i][j] == x[j][i])
		pass	

#Constraint for a floor of satisfiability
#This constraint makes it so that every person has some minimum of happiness
#	or unhappiness. That way you won't have 10 extremely happy groups and 
#	2 extremely miserable groups. It spreads out the love a bit more.
#THIS ADDS A LOT OF TIME TO COMPUTATION
for i in range(m):
	#p.add_constraint(sum([c[i][j] * x[i][j] for j in range(m)]) >= min([f for f in c[i]]))
	pass


#Constraint that the size of the set of all groups is m/numPartners
#I have no idea how to do this. Partioning a graph into N complete graphs?
#Can't do this in MIPS apparently. I might try it later.


#Objective function
#This is the function that determines the "happiness" or "unhappiness".
#	Basically it takes each (i,j) in cost matrix and multiples it by (i,j)
#	in the answer matrix. Notice the answer matrix, for any (i,j), is 0 or 1.
#	It then sums up all of these numbers, resulting in an overall summation
#	of either the net happiness or net unhappiness, depending how you made
#	the cost matrix.
p.set_objective(sum([x[i][j] * c[i][j] for i in range(m) for j in range(n)]))

#Printing results
#p.solve() is the main method - you only have to run it once.
#	From there you can run p.show() and mess with the results as you want.
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