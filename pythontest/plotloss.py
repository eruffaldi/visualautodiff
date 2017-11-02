from matplotlib import pyplot;
from pylab import genfromtxt;  
import sys
mat0 = genfromtxt(sys.argv[1]);
print mat0.shape
if len(mat0.shape) == 1:
	pyplot.plot(mat0, label = "loss");
else:
	pyplot.plot(mat0[:,0],mat0[:,1], label = "loss");
pyplot.legend();
pyplot.show();