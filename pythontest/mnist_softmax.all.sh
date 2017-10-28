#!/bin/bash
python mnist_softmax.py -w
python mnist_softmax.py -w --no-gpu
python mnist_softmax.py -w --no-gpu --singlecore
