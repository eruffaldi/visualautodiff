import sys
import json
import scipy.io
import argparse
import os
import numpy as np

def main():

	parser = argparse.ArgumentParser(description='Process some integers.')
	parser.add_argument('-i','--inputpath')
	parser.add_argument('-o','--outputpath',default=".")
	
	args = parser.parse_args()

	for x in os.listdir(args.inputpath):
		if not x.endswith(".mat"):
			continue

		fp =os.path.join(args.inputpath,x)
		m = scipy.io.loadmat(fp)
		cfp = os.path.join(args.inputpath,"cm",x)
		lfp = os.path.join(args.inputpath,"loss",x)
		cm = scipy.io.loadmat(cfp)
		lom = scipy.io.loadmat(lfp)
		print lom
		base = os.path.join(args.outputpath,os.path.splitext(x)[0] + ".json")
		r = m["data"]
		dd = dict([(n,r[n].item(0).item(0)) for n in r.dtype.names])
		print x
		print dd
		print "emitting",base
		json.dump(dd,open(base,"wb"))
		np.savetxt(base + ".cm.txt",cm["cm"])
		if "loss" in lom:
			np.savetxt(base + ".loss.txt",lom["loss"])


if __name__ == '__main__':
	main()