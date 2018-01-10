#!/bin/bash
TIMES=10
for i in {1..$TIMES}; do python mnist_softmax.py -w --id C1; done 
for i in {1..$TIMES}; do python mnist_softmax.py -w --no-gpu --id C4; done  
for i in {1..$TIMES}; do python mnist_softmax.py -w --no-gpu --singlecore --id C3; done
