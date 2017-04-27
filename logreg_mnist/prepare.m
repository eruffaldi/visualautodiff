addpath logreg_mnist
Trimages = loadMNISTImages('train-images-idx3-ubyte')';
Trlabels = loadMNISTLabels('train-labels-idx1-ubyte')';
Teimages = loadMNISTImages('t10k-images-idx3-ubyte')';
Telabels = loadMNISTLabels('t10k-labels-idx1-ubyte')';