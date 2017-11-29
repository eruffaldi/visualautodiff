


deftype = DeepOp.setgetDefaultType(single(0));
colmajor=1;
s = 512;
a = cast(imresize(imread('Lenna.png'),[s,s]),'single')/255.0;
%a =a(:,:,1);
%a =mallindex(size(a));
C =size(a,3);
flipmajor = @(x) permute(x,ndims(x):-1:1);
if colmajor % CWHB
    a1 = flipmajor(a);
    a1size=size(a1)
    a = reshape(a1,[size(a1),1]); % B=1,last 1 is discarded
    current2imageorder = flipmajor;
else % BHWC
    a = reshape(a,[1,size(a)]);
    current2imageorder = @(x) x;
end
size(a)

opImage = Variable('image',zeros(size(a)));
opImage.set(a);

%%

size(opImage.xvalue)

imgMax = MaxPoolOp(opImage,[1, 2, 2, 1],[1, 1, 1, 1],'SAME',colmajor); 
imgMax.evalshape();
imgMax.eval();
imgMax.grad(ones(size(imgMax.xvalue)));
figure(1)
imshow(squeeze(current2imageorder(imgMax.xvalue)));
oo = [];
oo.outpusize = size(imgMax.xvalue);
oo.inputsize = size(opImage.xvalue);
oo
opImage.xgrad;
%%
% W is natively rowmajor: whCQ
W0 = zeros([2,2,C,3]); % natively is romajor: k k Fi Fo => colmajor: Fo Fi k k 
%W(2,2,1,1) = 1.0/3; % identity
%W(2,2,2,1) = 1.0/3; % identity
%W(2,2,3,1) = 1.0/3; % identity
k=4;
W0(:,:,1,2) = 1.0; % take green and emit blue
%W0(:,:,1,2) = 1.0; % take green and emit blue
%W0(:,:,3,3) = 1.0; % take green and emit blue
W0 =W0/k;

W =  current2imageorder(W0);
if ndims(W0) < 4 && ndims(W) < 4
    size(W0)
    W = reshape(W,[ones(1,4-ndims(W0)),size(W)]);
    size(W)
end


opW = Placeholder('W',size(W));
opW.set(W);



imgOp = Conv2dOp(opImage,opW,[1, 1, 1, 1],'SAME',colmajor);
imgOp.evalshape();
imgOp.eval();
size(imgOp.xvalue)
figure(2)
imshow(squeeze(current2imageorder(imgOp.xvalue)));
imgOp.grad(ones(size(imgOp.xvalue)));
g=opImage.xgrad;
figure(3)
imshow(squeeze(current2imageorder(g/max(g(:)))));


