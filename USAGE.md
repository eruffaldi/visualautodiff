
# Once

## Build

mex -O SyncTime.c
mex -O sfun_loadmnist.c
mex -O ../commondeep/accummatrix.cpp -outdir ../commondeep
mex -O ../commondeep/gethermatrix.cpp -outdir ../commondeep

## Downoad MNIST

Required to have the files (four files, 52MB uncompressed)

# Always

init.m

# Library

ad_blocks.slx

# Testing

mnist_cnn_adam.slx
mnist_softmax_adam_whole.slx



