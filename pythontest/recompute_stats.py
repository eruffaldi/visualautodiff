import sys
import numpy as np 
import json
from confusionmatrixinfo import *


def main():
	for x in sys.argv[1:]:
		cmf = x+".cm.txt"
		cm = np.loadtxt(cmf).astype(np.int32)
		print x
		f = json.load(open(x,"rb"))
		mm = MulticlassStat(cm)
		#cmre = np.mean(np.array([[mm.TP,mm.FP],[mm.TN,mm.FN]],dtype=np.int32),axis=2)
		#print cmre
		print mm.accuracy,"vs stored",f["cm_accuracy"],f["accuracy"]
		print mm.Fscore,"vs stored",f["cm_Fscore"]
		print cm
		f["cm_accuracy"] = f["accuracy"]
		json.dump(f,open(x,"wb"))
	pass
if __name__ == '__main__':
	main()