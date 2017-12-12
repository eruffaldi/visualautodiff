# Original https://github.com/aymericdamien/TensorFlow-Examples/blob/master/examples/3_NeuralNetworks/recurrent_network.py

"""A deep MNIST classifier using LSTM

See extensive documentation at
https://www.tensorflow.org/get_started/mnist/pros
"""
# Disable linter warnings to maintain consistency with tutorial.
# pylint: disable=invalid-name
# pylint: disable=g-bad-import-order

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import print_function

import tensorflow as tf
from tensorflow.contrib import rnn
import time
import math
import argparse
import sys
import json
import numpy as np
import uuid
from tensorflow.examples.tutorials.mnist import input_data
from confusionmatrixinfo import *

import tensorflow as tf

from sys import platform
FLAGS = None

def machine():
  return dict(linux="glx64",darwin="maci64",win32="win32").get(platform)


def weight_variable(shape):
  """weight_variable generates a weight variable of a given shape."""
  initial = tf.truncated_normal(shape, stddev=0.1)
  return tf.Variable(initial)


def bias_variable(shape):
  """bias_variable generates a bias variable of a given shape."""
  initial = tf.constant(0.1, shape=shape)
  return tf.Variable(initial)

def RNN(x, timesteps,num_hidden,num_input=28,num_classes=10,forget_bias=1.0):

  weights = tf.Variable(tf.random_normal([num_hidden, num_classes]))
  biases = tf.Variable(tf.random_normal([num_classes]))

  # Prepare data shape to match `rnn` function requirements
  # Current data input shape: (batch_size, timesteps, n_input)
  # Required shape: 'timesteps' tensors list of shape (batch_size, n_input)

  # Unstack to get a list of 'timesteps' tensors of shape (batch_size, n_input)
  x = tf.unstack(x, timesteps, 1)

  # Define a lstm cell with tensorflow
  lstm_cell = rnn.BasicLSTMCell(num_hidden, forget_bias=forget_bias)

  # Get lstm cell output
  outputs, states = rnn.static_rnn(lstm_cell, x, dtype=tf.float32)

  logits = tf.matmul(outputs[-1], weights) + biases
  return logits



def main(_):
  # Import data
  mnist = input_data.read_data_sets(FLAGS.data_dir, one_hot=True)

  num_input = 28
  timesteps = 28
  num_classes = 10

  # Create the model
  x = tf.placeholder(tf.float32, [None, timesteps, num_input])

  # Define loss and optimizer
  y_ = tf.placeholder(tf.float32, [None, num_classes])

  # Build the graph for the deep net
  y_conv = RNN(x,timesteps=timesteps,num_input=num_input,num_hidden=FLAGS.hidden,forget_bias=FLAGS.forgetbias)#filter1_size=FLAGS.filter1,filter2_size=FLAGS.filter2,features1=FLAGS.features2,features2=FLAGS.features2,densesize=FLAGS.dense)

  total_parameters = 0
  for variable in tf.trainable_variables():
      # shape is an array of tf.Dimension
      shape = variable.get_shape()
      print(variable.name,shape,len(shape))
      variable_parametes = 1
      for dim in shape:
          print("\t",dim)
          variable_parametes *= dim.value
      print("\t\tparametes:",variable_parametes)
      total_parameters += variable_parametes
  print("Total Parameters",total_parameters)


  cross_entropy = tf.reduce_mean(
      tf.nn.softmax_cross_entropy_with_logits(labels=y_, logits=y_conv))

  if FLAGS.adam:
    train_step = tf.train.AdamOptimizer(FLAGS.adam_rate).minimize(cross_entropy) #GradientDescentOptimizer(0.5).minimize(cross_entropy)
  else:
    train_step = tf.train.GradientDescentOptimizer(FLAGS.gradient_rate).minimize(cross_entropy) #GradientDescentOptimizer(0.5).minimize(cross_entropy)

  kw = {}
  if FLAGS.no_gpu:
    kw["device_count"] = {'GPU': 0  }
  if FLAGS.singlecore:
    kw["intra_op_parallelism_threads"]=1
    kw["inter_op_parallelism_threads"]=1

  iterations = FLAGS.epochs*int(math.ceil(60000.0/FLAGS.batchsize))
  config = tf.ConfigProto(**kw)
  sess = tf.InteractiveSession(config=config)
  #train_step = tf.train.AdamOptimizer(1e-4).minimize(cross_entropy)
  predictions = tf.argmax(y_conv, 1)
  correct_prediction = tf.equal(predictions, tf.argmax(y_, 1))
  accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))

  if True: #with tf.Session() as sess:
    sess.run(tf.global_variables_initializer())
    t0 = time.time()
    losses = np.zeros((iterations,1))
    for i in range(iterations):
      batch = mnist.train.next_batch(FLAGS.batchsize)
      batch0 = batch[0].reshape((FLAGS.batchsize, 28, 28))

      if False and i % 100 == 0:
        train_accuracy = accuracy.eval(feed_dict={
            x: batch0, y_: batch[1]})
        print('step %d, training accuracy %g' % (i, train_accuracy))
      _,cross_entropy_value = sess.run([train_step,cross_entropy], feed_dict={x: batch0, y_: batch[1]})
      losses[i] = cross_entropy_value
      #train_step.run(feed_dict={x: batch[0], y_: batch[1], keep_prob: 0.5})
    training_time = time.time()-t0
    print ("training_time",training_time)
    print ("iterations",iterations)
    print ("batchsize",FLAGS.batchsize)

    t0 = time.time()
    evaliterations = int(math.ceil(10000.0/FLAGS.batchsize))
    accuracyvalue = 0
    accuracyvaluecount = 0
    cm = None
    for i in range(evaliterations):
      batch = mnist.test.next_batch(FLAGS.batchsize)
      batch0 = batch[0].reshape((FLAGS.batchsize, 28, 28))
      accuracyvalue += accuracy.eval(feed_dict={
        x: batch0, y_: batch[1]})
      accuracyvaluecount += 1
      cma = sess.run(tf.contrib.metrics.confusion_matrix(tf.argmax(y_, 1),predictions,num_classes),feed_dict={x: batch0,y_: batch[1]})
      if cm is None:
        cm =  cma
      else:
        cm += cma
    accuracyvalue /= accuracyvaluecount

    test_time = time.time()-t0
    print('test accuracy %g' % accuracyvalue)
    print("test time",test_time)
    print (cm)
    qs = MulticlassStat(cm)
    cm_accuracy = qs.accuracy
    cm_Fscore = qs.Fscore
    cm_sensitivity = qs.recall
    cm_fpr = qs.fpr

    print ("test CM accuracy",cm_accuracy,"CM F1",cm_Fscore)

    go = str(uuid.uuid1())+'.json';
    args = FLAGS
    out = dict(accuracy=float(accuracyvalue),training_time=training_time,single_core=1 if args.singlecore else 0,implementation="tf",type='single',test='lstm',gpu=0 if args.no_gpu else 1,machine=machine(),epochs=args.epochs,batchsize=args.batchsize,now_unix=time.time(),lstm_specs=(args.hidden,args.forgetbias),cm_accuracy=float(cm_accuracy),cm_Fscore=float(cm_Fscore),iterations=iterations,testing_time=test_time,total_params=total_parameters,cm_fpr=float(cm_fpr),use_adam=FLAGS.adam,rate=FLAGS.adam_rate if FLAGS.adam else FLAGS.gradient_rate)
    open(go,"w").write(json.dumps(out))
    np.savetxt(go+".loss.txt", losses)
    np.savetxt(go+".cm.txt", cm)
    
if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  parser.add_argument('--data_dir', type=str,
                      default='/tmp/tensorflow/mnist/input_data',
                      help='Directory for storing input data')
  parser.add_argument('-t', '--timesteps',type=int,default=28,help='');
  parser.add_argument('-f', '--forgetbias',type=float,default=1.0,help='');
  parser.add_argument('-H','--hidden',type=int,default=128,help='');

  parser.add_argument('--no-gpu',action="store_true")
  parser.add_argument('--singlecore',action="store_true")
  parser.add_argument('--adam',action="store_true")
  parser.add_argument('--adam_rate',default=1e-4,type=float)
  parser.add_argument('--gradient_rate',default=0.5,type=float)
  parser.add_argument('--epochs',help="epochs",default=5,type=int)
  parser.add_argument('--batchsize',help="batch size",type=int,default=100)
  parser.add_argument('-w',action="store_true")
  FLAGS, unparsed = parser.parse_known_args()

  tf.app.run(main=main, argv=[sys.argv[0]] + unparsed)
