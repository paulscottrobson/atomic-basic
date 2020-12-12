# *****************************************************************************
# *****************************************************************************
#
#		Name:		errors.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		10 Dec 2020
#		Purpose:	Error Generator class
#
# *****************************************************************************
# *****************************************************************************

import re,os,sys

# *****************************************************************************
#
#						Error source generator class
#
# *****************************************************************************

class ErrorGenerator(object):
	def __init__(self):
		self.errors = {}
	#
	#		Load a file in as an array of strings
	#
	def load(self,s):
		s = [x if x.find(";") < 0 else x[:x.find(";")] for x in s]
		s = [x.replace("\t"," ").strip() for x in s if x.strip() != ""]
		for c in s:
			m = re.match("^([A-Za-z]+)\\:(.*)$",c)
			assert m is not None,"Bad error definition "+c
			assert m.group(1) not in self.errors,"Duplicate error "+c
			self.errors[m.group(1)] = m.group(2).strip()
	#
	#		Write out error handlers
	#
	def write(self,h):
		h.write(";\n;\tGenerated by errors.py\n;\n")
		eKeys = [x for x in self.errors.keys()]
		eKeys.sort()
		for k in eKeys:
			h.write('EHandler{0}:\n\tjsr\tErrorHandler\n\t.text "{1}",0\n'.format(k,self.errors[k]))
if __name__ == "__main__":
	eg = ErrorGenerator()
	eg.load("""
;
;		Test Error Generator file.
;
NotImplemented:	Not implemented
TypeMismatch:	Type Mismatch
Syntax:			Syntax Error
DivideZero:		Divide by Zero
Assert:			Assert Failed
LineNumber:		Unknown line
Stop:			Stop
NoGosub:		Return without Gosub
NoRepeat:		Until without Repeat
NoProc:			EndProc without Proc
Memory:			Insufficient Memory
NoWhile:		Wend without While
Closure:		Structure Error
BadProc:		Unknown Procedure
Parameters:		Bad Parameters
BadIndex:		Wrong Next index
NoArray:		Bad Array
BadAIndex:		Bad Array Index

""".split("\n"))
	eg.write(open("../source/common/generated/errors.asm","w"))
	#eg.write(sys.stdout)