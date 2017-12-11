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

"""A deep MNIST classifier using convolutional layers.

See extensive documentation at
https://www.tensorflow.org/get_started/mnist/pros
"""
# Disable linter warnings to maintain consistency with tutorial.
# pylint: disable=invalid-name
# pylint: disable=g-bad-import-order

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
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

from capsnet.config import cfg
from capsnet.capsNet import CapsNet


def main(_):
  # Import data
  mnist = input_data.read_data_sets(FLAGS.data_dir, one_hot=True)

  kw = {}
  if FLAGS.no_gpu:
    kw["device_count"] = {'GPU': 0  }
  if FLAGS.singlecore:
    kw["intra_op_parallelism_threads"]=1
    kw["inter_op_parallelism_threads"]=1

  BS = FLAGS.batchsize  #
  EPO = FLAGS.epochs

  cfg.batchsize = BS
  cfg.epoch = EPO


  iterations = FLAGS.epochs*int(math.ceil(60000.0/FLAGS.batchsize))
  evaliterations = int(math.ceil(10000.0/FLAGS.batchsize))
  config = tf.ConfigProto(**kw)


  if not FLAGS.test_only:
    print ("building CapsNet for training")
    capsNetTr = CapsNet(BS,features2=FLAGS.features2,dense1=FLAGS.dense1,dense2=FLAGS.dense2,features1=FLAGS.features1,is_training=True)
    cfg.is_training = True
    with capsNetTr.graph.as_default():
      #sv = tf.train.Supervisor(graph=capsNet.graph,
      #                        logdir=cfg.logdir,
      #                         save_model_secs=0)
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

      x = capsNetTr.X
      y_ = capsNetTr.Y
      sv = tf.train.Supervisor(logdir=cfg.logdir)
      with sv.managed_session(config=config) as sess:  
        #predictions = tf.argmax(y_conv, 1)
        #correct_prediction = tf.equal(predictions, tf.argmax(y_, 1))
        #accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))
        t0 = time.time()
        losses = np.zeros((iterations,1))
        # TODO: decoded is full image need to specify differently
        cross_entropy = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(labels=y_, logits=capsNetTr.predicted))
        for i in range(iterations):
          batch = mnist.train.next_batch(FLAGS.batchsize)
          _,cross_entropy_value = sess.run([capsNetTr.train_op,cross_entropy], feed_dict={x: batch[0], y_: batch[1]})
          losses[i] = cross_entropy_value
        global_step = sess.run(capsNetTr.global_step) # unknown meaning 
        training_time = time.time()-t0
        print ("done ... saving")
        sv.saver.save(sess, cfg.logdir + '/model_epoch_%04d_step_%02d' % (epoch, global_step))

        print ("training_time",training_time)
        print ("iterations",iterations)
        print ("batchsize",FLAGS.batchsize)

  # Create the model

  cfg.is_training = False
  capsNetTe = CapsNet(BS,features2=FLAGS.features2,dense1=FLAGS.dense1,dense2=FLAGS.dense2,features1=FLAGS.features1,is_training=False)

  # Build the graph for the deep net
  with capsNetTe.graph.as_default():
      x = capsNetTe.X
      y_ = capsNetTe.Y
      sv = tf.train.Supervisor(logdir=cfg.logdir)
      with sv.managed_session(config=config) as sess:  
        print ("restoring for evaluation")
        sv.saver.restore(sess, tf.train.latest_checkpoint(cfg.logdir))
        print ("go!")
        t0 = time.time()
        accuracyvalue = 0
        accuracyvaluecount = 0
        reconstruction_err = []
        cm = None
        # TODO: decoded is full image need to specify differently
        predictions = capsNetTe.predicted
        correct_prediction = tf.equal(predictions, tf.argmax(y_, 1))
        accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))
        for i in range(evaliterations):
            batch = mnist.test.next_batch(FLAGS.batchsize)
            accuracyvalue += accuracy.eval(feed_dict={
              x: batch[0], y_: batch[1], keep_prob: 1.0})
            accuracyvaluecount += 1
            cma = sess.run(tf.contrib.metrics.confusion_matrix(tf.argmax(y_, 1),predictions,10),feed_dict={x: batch[0],y_: batch[1], keep_prob: 1.0})
            if cm is None:
              cm =  cma
            else:
              cm += cma
            accuracyvalue /= accuracyvaluecount
        testing_time = time.time()-t0


  if True:
    print('test accuracy %g' % accuracyvalue)

    print (cm)
    qs = MulticlassStat(cm)
    cm_accuracy = qs.accuracy
    cm_Fscore = qs.Fscore
    cm_sensitivity = qs.recall
    cm_fpr = qs.fpr

    print ("test CM accuracy",cm_accuracy,"CM F1",cm_Fscore)

    go = str(uuid.uuid1())+'.json';
    args = FLAGS
    out = dict(accuracy=float(accuracyvalue),training_time=training_time,single_core=1 if args.singlecore else 0,implementation="tf",type='single',test='cnn',gpu=0 if args.no_gpu else 1,machine=machine(),epochs=args.epochs,batchsize=args.batchsize,now_unix=time.time(),cnn_specs=(args.filter1,args.filter2,args.features1,args.features2,args.dense),cm_accuracy=float(cm_accuracy),cm_Fscore=float(cm_Fscore),iterations=iterations,testing_time=test_time,total_params=total_parameters,cm_fpr=float(cm_fpr),use_adam=FLAGS.adam,rate=FLAGS.adam_rate if FLAGS.adam else FLAGS.gradient_rate)
    open(go,"w").write(json.dumps(out))
    np.savetxt(go+".loss.txt", losses)
    np.savetxt(go+".cm.txt", cm)
    
if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  parser.add_argument('--data_dir', type=str,
                      default='/tmp/tensorflow/mnist/input_data',
                      help='Directory for storing input data')
  parser.add_argument('--no-gpu',action="store_true")
  parser.add_argument('--singlecore',action="store_true")
  parser.add_argument('--test-only',action="store_true")
  parser.add_argument('-a', '--features1',type=int,default=256,help='first features size');
  parser.add_argument('-b', '--features2',type=int,default=32,help='second features size');
  parser.add_argument('-d','--dense1',type=int,default=512,help='dense bank');
  parser.add_argument('-D','--dense2',type=int,default=1024,help='dense bank');
  parser.add_argument('--original',action="store_true",help='picks original CapsNet values (8M parameters)')
  parser.add_argument('--light',action="store_true",help='light values (? parameters)')
  #parser.add_argument('-A','--features1',type=int,default=32,help='features of first');
  #parser.add_argument('-B','--features2',type=int,default=64,help='features of second');
  parser.add_argument('--adam_rate',default=1e-4,type=float)
  parser.add_argument('--epochs',help="epochs",default=5,type=int)
  parser.add_argument('--batchsize',help="batch size",type=int,default=100)
  parser.add_argument('-w',action="store_true")
  FLAGS, unparsed = parser.parse_known_args()
  if FLAGS.original:
    # 1M
    FLAGS.features1 = 256
    FLAGS.features2 = 32
    FLAGS.dense1= 512
    FLAGS.dense2=1024
  elif FLAGS.light:
    # 400k
    FLAGS.features1 = 256
    FLAGS.features2 = 16
    FLAGS.dense1= 256
    FLAGS.dense2=256

  tf.app.run(main=main, argv=[sys.argv[0]] + unparsed)
