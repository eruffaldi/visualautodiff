
# Once

## Build

    setup.m

This script does:
- build some Mex
- downloads MNIST
- unpacks MNIST

# Always

    init.m

# Library

    ad_blocks.slx

# Testing

Use the following two:

    mnist_cnn_adam.slx
    mnist_softmax_adam_whole.slx

Example from command line:

    tic
    sim('mnist_cnn_adam')
    toc

And

    tic
    sim('mnist_softmax_adam_whole')
    toc

# Issues

sim('mnist_cnn_adam')


