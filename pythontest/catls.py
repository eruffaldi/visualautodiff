import base64
import sys

#https://www.iterm2.com/utilities/imgls
def encode_iterm2_image(data,height=None):
	if height is None:
		height = "auto"
	else:
		height = "%spx" % height
	return ("\x1B]1337;File=loss.jpg;width=auto;height=%s;inline=1;size=%dpreserveAspectRatio=1:" % (height,len(data))) + base64.b64encode(data)


print encode_iterm2_image(open(sys.argv[1],"rb").read(),100)