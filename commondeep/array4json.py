import numpy as np


def encodematrix4json(s,order=None):
	if type(s) is np.ndarray:
		meorder = 'F' if np.isfortran(s) else 'C'

		if order is None:
			order = meorder

		r = {}
		r["shape"] = s.shape
		r["type"] = s.dtype.name
		if meorder != order:
			s = np.transpose(s,range(len(shape)-1,0,-1))
		if False:
			r["data"] = s.tobytes()
		else:
			r["data"] = s.view(dtype=np.uint8).tolist() #THIS GIVES PROBLEMS: s.tobytes()

		r["order"] = order
		return r
	else:
		return s

def decodematrix4json(s):
	if type(s) == list:
		return np.array(s,dtype=np.float32)
	else:
		t = s["type"]
		if t == "float" or t == "single":
			t = "float32"
		elif t == "double":
			t = "float64"
		dt = np.dtype(t)
		if type(s["data"]) is list:
			d = np.array(s["data"],dtype=np.uint8).view(dtype=dt)
		else:
			d = np.frombuffer(s["data"],dt)
		if s["order"] != "C":
			return np.transpose(np.reshape(d,s["shape"][:-1:0]))
		else:
			return np.reshape(d,s["shape"])


if __name__ == '__main__':
	q = np.random.rand(3,2)
	s = encodematrix4json(q)
	print "length of encoding",s
	qe = decodematrix4json(s)
	print (q-qe)
	