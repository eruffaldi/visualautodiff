


deftype = DeepOp.setgetDefaultType(single(0));
colmajor = 0;
a = cast(imresize(imread('Lenna.png'),[512,512]),'single')/255.0;
if colmajor % CWHB
    a = permute(a,[3 2 1]);
    a = reshape(a,[size(a),1]); % B=1
    flipmajor = @(x) permute(x,ndims(x):-1:1);
else % BHWC
    a = reshape(a,[1,size(a)]);
    flipmajor = @(x) x;
end
size(a)

opImage = Placeholder('image',size(a));
opImage.set(a);

%%

size(opImage.xvalue)

imgMax = MaxPoolOp(opImage,[1, 2, 2, 1],[1, 2, 2, 1],'SAME',colmajor); 
imgMax.evalshape();
imgMax.eval();
size(imgMax.xvalue)
figure(1)

imshow(squeeze(flipmajor(imgMax.xvalue)));

%%
% below is major
W = zeros([1,3,3,3]);
W(:,1,2,2) = 1.0; % identity
W(:,2,2,2) = 1.0; % identity
W(:,3,2,2) = 1.0; % identity
if colmajor == 0
    W =  permute(W,ndims(4):-1:1);
end


opW = Placeholder('W',size(W));
opW.set(W);

imgOp = Conv2dOp(opImage,opW,[1, 1, 1, 1],'SAME',colmajor);
imgOp.evalshape();
imgOp.eval();
size(imgOp.xvalue)
figure(2)
imshow(squeeze(flipmajor(imgOp.xvalue)));

imshow(squeeze(permute(imgOp.xvalue,[4,3,2,1])));
