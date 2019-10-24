%%
mex -O autodiffLib/SyncTime.c -outdir autodiffLib
mex -O autodiffLib/sfun_loadmnist.c -outdir commondeep
mex -O commondeep/accummatrix_rm.cpp -outdir commondeep
mex -O commondeep/accummatrix_cm.cpp -outdir commondeep

%%
urls = {'http://yann.lecun.com/exdb/mnist/train-images-idx3-ubyte.gz','http://yann.lecun.com/exdb/mnist/train-labels-idx1-ubyte.gz','http://yann.lecun.com/exdb/mnist/t10k-images-idx3-ubyte.gz','http://yann.lecun.com/exdb/mnist/t10k-labels-idx1-ubyte.gz'};
for I=1:length(urls)
    k = find(urls{I}=='/',1,'last');
    name = ['logreg_mnist' filesep urls{I}(k+1:end)];
    if exist(name,'file') == 0
        disp(['Downloading ',urls{I}]);
        urlwrite(urls{I},name);
    end
    k = find(name=='.',1,'last');
    namepure = name(1:k-1);
    if exist(namepure,'file') == 0
        disp(['Unpacking ',name])
        gunzip(name,'logreg_mnist');
    end
end

%%
if exist('logreg_mnist/train-images-idx3-ubyte-le','file') == 0
    disp('converting MNIST')
    cd logreg_mnist
    mnistweb2matlabnice
end
disp('Ready')
