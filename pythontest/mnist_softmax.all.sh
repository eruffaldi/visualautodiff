#!/bin/bash
for i in {1..10}; do echo "--------------- C1 $i"; python mnist_softmax.py -w --id C1; done 
for i in {1..10}; do echo "--------------- C4 $i"; python mnist_softmax.py -w --no-gpu --id C4; done  
for i in {1..10}; do echo "--------------- C3 $i"; python mnist_softmax.py -w --no-gpu --singlecore --id C3; done
