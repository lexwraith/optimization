import random

def generate(men,women):
	with open("mydata.dzn", "w") as myfile:
		myfile.write("rows = " + str(men) + ";\n")
		myfile.write("cols = " + str(women) + ";\n")
		mycostmatrix = [[str(random.randint(1,30)) for cols in range(women)] for rows in range(men) ]		
		myfile.write("cost = \n[|")
		for rows in range(men):
			for cols in range(women):
				myfile.write(mycostmatrix[rows][cols] + ",")
			myfile.write("\n|")
		myfile.write("];\n")
		myfile.write("K = \n[")		
		maxmarriage = []
		while(sum(maxmarriage) != women):
			maxmarriage = [random.randint(1,women/men + women/2) for i in range(men)]
		for k in range(len(maxmarriage)):
			myfile.write(str(maxmarriage[k]))
			if(k < len(maxmarriage) - 1) : myfile.write(",")
		myfile.write("];\n")

generate(2,5)
