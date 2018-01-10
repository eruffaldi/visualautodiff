#!/bin/bash
for i in {1..10}; do echo "--------------- C1 $i"; python mnist_cnn.py -w --p57 --id C1; done
for i in {1..10}; do echo "--------------- C4 $i"; python mnist_cnn.py -w --p57 --no-gpu --id C4; done
for i in {1..10}; do echo "--------------- C3 $i"; python mnist_cnn.py -w --p57 --no-gpu --singlecore --id C3; done
