# Copyright 2015 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Modified by Emanuele Ruffaldi 2017
# 
# ==============================================================================

"""A very simple MNIST classifier.

See extensive documentation at
https://www.tensorflow.org/get_started/mnist/beginners
"""
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import math
import time
import argparse
import sys
import json
import numpy as np
import uuid

from tensorflow.examples.tutorials.mnist import input_data

import tensorflow as tf
from sys import platform
from confusionmatrixinfo import *

FLAGS = None

def machine():
  return dict(linux="glx64",darwin="maci64",win32="win32").get(platform,"other")



def main(_):
  # Import data
  print ("updated")
  mnist = input_data.read_data_sets(FLAGS.data_dir, one_hot=True)

  # Create the model
  x = tf.placeholder(tf.float32, [None, 784])
  W = tf.Variable(tf.zeros([784, 10]))
  b = tf.Variable(tf.zeros([10]))
  y = tf.matmul(x, W) + b

  # Define loss and optimizer
  y_ = tf.placeholder(tf.float32, [None, 10])

  # The raw formulation of cross-entropy,
  #
  #   tf.reduce_mean(-tf.reduce_sum(y_ * tf.log(tf.nn.softmax(y)),
  #                                 reduction_indices=[1]))
  #
  # can be numerically unstable.
  #
  # So here we use tf.nn.softmax_cross_entropy_with_logits on the raw
  # outputs of 'y', and then average across the batch.
  cross_entropy = tf.reduce_mean(
      tf.nn.softmax_cross_entropy_with_logits(labels=y_, logits=y))
  if FLAGS.adam:
    train_step = tf.train.AdamOptimizer(FLAGS.adam_rate).minimize(cross_entropy) #GradientDescentOptimizer(0.5).minimize(cross_entropy)
  else:
    train_step = tf.train.GradientDescentOptimizer(FLAGS.gradient_rate).minimize(cross_entropy) #GradientDescentOptimizer(0.5).minimize(cross_entropy)

  total_parameters = 0
  for variable in tf.trainable_variables():
      # shape is an array of tf.Dimension
      shape = variable.get_shape()
      print(shape)
      print(len(shape))
      variable_parametes = 1
      for dim in shape:
          print(dim)
          variable_parametes *= dim.value
      print(variable_parametes)
      total_parameters += variable_parametes
  print("Total Parameters",total_parameters)
  kw = {}
  if FLAGS.no_gpu:
    kw["device_count"] = {'GPU': 0  }
  if FLAGS.singlecore:
    kw["intra_op_parallelism_threads"]=1
    kw["inter_op_parallelism_threads"]=1

  config = tf.ConfigProto(**kw)
  sess = tf.InteractiveSession(config=config)
  tf.global_variables_initializer().run()
  # Train
  iterations = FLAGS.epochs*int(math.ceil(60000.0/FLAGS.batchsize))
  t0 = time.time()
  losses = np.zeros((iterations,1))
  for i in range(iterations):
    batch_xs, batch_ys = mnist.train.next_batch(FLAGS.batchsize)
    _,cross_entropy_value = sess.run([train_step,cross_entropy], feed_dict={x: batch_xs, y_: batch_ys})
    losses[i] = cross_entropy_value
  training_time = time.time()-t0
  print ("training_time",training_time)
  print ("iterations",iterations)
  print ("batchsize",FLAGS.batchsize)

  # Test trained model
  predictions = tf.argmax(y, 1)
  correct_prediction = tf.equal(predictions, tf.argmax(y_, 1))
  t0 = time.time()
  accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))
  accuracyvalue = sess.run(accuracy, feed_dict={x: mnist.test.images,
                                      y_: mnist.test.labels})
  test_time = time.time()-t0
  cm = sess.run(tf.contrib.metrics.confusion_matrix(tf.argmax(y_, 1),predictions,10),feed_dict={x: mnist.test.images,
                                      y_: mnist.test.labels})


  print (cm)
  qs = MulticlassStat(cm)
  cm_accuracy = qs.accuracy
  cm_Fscore = qs.Fscore
  cm_sensitivity = qs.recall
  cm_fpr = qs.fpr
  print ("test CM accuracy",cm_accuracy,"CM F1",cm_Fscore)

  go = str(uuid.uuid1())+'.json';
  args = FLAGS
  out = dict(accuracy=float(accuracyvalue),machine=machine(),training_time=training_time,implementation="tf",single_core=1 if args.singlecore else 0,type='single',test='softmax',gpu=0 if args.no_gpu else 1,epochs=args.epochs,batchsize=args.batchsize,now_unix=time.time(),cm_accuracy=float(cm_accuracy),cm_Fscore=float(cm_Fscore),iterations=iterations,testing_time=test_time,total_params=total_parameters,cm_fpr=float(cm_fpr),use_adam=FLAGS.adam,rate=FLAGS.adam_rate if FLAGS.adam else FLAGS.gradient_rate)
  open(go,"w").write(json.dumps(out))
  np.savetxt(go+".loss.txt", losses)
  np.savetxt(go+".cm.txt", cm)
    
if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  parser.add_argument('--data_dir', type=str, default='/tmp/tensorflow/mnist/input_data',
                      help='Directory for storing input data')
  parser.add_argument('--no-gpu',action="store_true")
  parser.add_argument('--singlecore',action="store_true")
  parser.add_argument('--adam',action="store_true")
  parser.add_argument('--adam_rate',default=1e-4,type=float)
  parser.add_argument('--gradient_rate',default=0.5,type=float)
  parser.add_argument('--epochs',help="epohcs",type=int,default=5)
  parser.add_argument('--batchsize',help="batch size",type=int,default=100)
  parser.add_argument('-w',action="store_true")
  FLAGS, unparsed = parser.parse_known_args()
  tf.app.run(main=main, argv=[sys.argv[0]] + unparsed)