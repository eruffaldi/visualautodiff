[Trimages,Trraw,Trinfo] = loadMNISTImages('train-images-idx3-ubyte');
Trlabels = loadMNISTLabels('train-labels-idx1-ubyte')';
[Teimages,Teraw,Teinfo] = loadMNISTImages('t10k-images-idx3-ubyte');
Telabels = loadMNISTLabels('t10k-labels-idx1-ubyte')';

%%
%save mnist_train Trimages Trlabels
%save mnist_test Teimages Telabels

%%
saveMNISTImagesLE('train-images-idx3-ubyte-le',Trimages,Trraw,Trinfo);
saveMNISTImagesLE('t10k-images-idx3-ubyte-le',Teimages,Teraw,Teinfo);

saveMNISTLabelsLE('train-labels-idx1-ubyte-le',Trlabels);
saveMNISTLabelsLE('t10k-labels-idx1-ubyte-le',Telabels);

%% save little endian