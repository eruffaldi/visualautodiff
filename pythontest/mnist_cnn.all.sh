#!/bin/bash
python mnist_cnn.py -w --p57 
python mnist_cnn.py -w --p57 --no-gpu
python mnist_cnn.py -w --p57 --no-gpu --singlecore
