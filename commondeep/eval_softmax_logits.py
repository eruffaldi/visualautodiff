import tensorflow as tf
import json
import numpy as np
import argparse
from array4json import * 


def main():
	parser = argparse.ArgumentParser(description='Tests ')
	parser.add_argument('-i',"--input",default="input.json")
	parser.add_argument('-o',"--output",default="output.json")

	args = parser.parse_args()

	d = json.load(open(args.input,"rb"))

	logitsdata = decodematrix4json(d["logits"]) #np.array(d["logits"],dtype=np.float32);
	labelsdata = decodematrix4json(d["labels"]) #np.array(d["labels"],dtype=np.float32);

	print  ("input",logitsdata.shape," ",labelsdata.shape)

	#logits = tf.Variable(tf.zeros([None, 10]))
	logits = tf.placeholder(tf.float32, [None, 2])
	labels = tf.placeholder(tf.float32, [None, 2])

	fx = tf.nn.softmax_cross_entropy_with_logits(labels=labels,logits=logits)
	#fx2 = tf.gradients(fx, [logits])[0]

	#config = tf.ConfigProto(**kw)
	sess = tf.InteractiveSession()#config=config)
	tf.global_variables_initializer().run()

	out = sess.run([fx], feed_dict={logits: logitsdata, labels: labelsdata})
	json.dump(dict(output=encodematrix4json(out[0])),open("output.json","wb"))

if __name__ == '__main__':
	main()