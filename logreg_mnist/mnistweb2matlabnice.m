[Trimages,Trraw,Trinfo] = loadMNISTImages('train-images.idx3-ubyte');
Trlabels = loadMNISTLabels('train-labels.idx1-ubyte')';
[Teimages,Teraw,Teinfo] = loadMNISTImages('t10k-images.idx3-ubyte');
Telabels = loadMNISTLabels('t10k-labels.idx1-ubyte')';

%%
%save mnist_train Trimages Trlabels
%save mnist_test Teimages Telabels

%%
saveMNISTImagesLE('train-images-idx3-ubyte-le',Trraw,Trinfo,0);
saveMNISTImagesLE('t10k-images-idx3-ubyte-le',Teraw,Teinfo,0);

saveMNISTLabelsLE('train-labels-idx1-ubyte-le',Trlabels);
saveMNISTLabelsLE('t10k-labels-idx1-ubyte-le',Telabels);

%%
%%
saveMNISTImagesLE('train-images-idx3-ubyte-le-T',Trraw,Trinfo,1);
saveMNISTImagesLE('t10k-images-idx3-ubyte-le-T',Teraw,Teinfo,1);

