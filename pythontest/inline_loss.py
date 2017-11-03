import sys
import numpy as np 
import json
import base64
import StringIO
import matplotlib.pyplot as plt
import sys

#https://www.iterm2.com/utilities/imgls
def encode_iterm2_image(data,height=None):
    if height is None:
        height = "auto"
    else:
        height = "%spx" % height
    return ("\x1B]1337;File=loss.jpg;width=auto;height=%s;inline=1;size=%dpreserveAspectRatio=1:" % (height,len(data))) + base64.b64encode(data) + "\a\033\\"


def main():
    for x in sys.argv[1:]:
        cmf = x+".loss.txt"
        mat0 = np.loadtxt(cmf)
        f = json.load(open(x,"rb"))

        plt.figure()
        if len(mat0.shape) == 1:
            plt.plot(mat0, label = "loss");
        else:
            plt.plot(mat0[:,0],mat0[:,1], label = "loss");
        plt.legend();
        buf = StringIO.StringIO()
        plt.savefig(buf,format="png")
        print cmf,f["test"],"gpu" if f["gpu"] else "","singlecore" if f["single_core"] else ""
        print encode_iterm2_image(buf.getvalue(),200)

if __name__ == '__main__':
    main()