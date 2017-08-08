%% Tests the: mpatchprepare, mpatcher, munpatcher
%
% Equivalent to Convolution
nC = 3;
nB = 6;
Ih = 10;
Iw = 10;
nFo = 2;
a = mallindex([nB,Ih,Iw,nC]);
filtersize = 5; 
padding = (filtersize-1)/2;
stride = [1,1];

mode = 'BPKC';
mode = 'BPCK';
[Sel,sXp,outshape,nameddims] = mpatchprepare(size(a),5,[1 1],2,mode); % N independent
% [nB,Fh,Fw,nC,nP]
Xp = mpatcher(a,Sel,sXp); 
% [nB , Fh Fw nC patches] -> [nB patches Fh Fw C]

iC = 2;
if nameddims.C == 5
    p1 = squeeze(Xp(1,1,:,:,iC)) % should have only 2nd and 3d moving
    p2 = squeeze(Xp(1,2,:,:,iC))
    squeeze(a(1,1:5,1:5,1)) 
else
    p1 = squeeze(Xp(1,1,iC,:,:)) % should have only 2nd and 3d moving
    p2 = squeeze(Xp(1,2,iC,:,:))
    squeeze(a(1,1:5,1:5,1)) 
end
    
% contributions from every patch to the original image
aX = munpatcher(ones(size(Xp)),Sel,size(a));
squeeze(aX(1,:,:,1)) % should be 25 in center, 9 in corner

% test product
%W = mones([filtersize,filtersize,nC,nFo]);
%Y = reshape(reshape(Xp,nB*sXp(2),[])*reshape(W,[],nFo),nB,outshape(1),outshape(2),nFo);


% %% The Max Pool requires a different treatment
% %
% dout = sum(mones(size(Y)),4); % N Ph Pw Fo incoming => N Ph Pw
% dxcol = mzeros([nB*prod(outshape),filtersize^2*nC]); % [nB*nP, nS] aka size(w)
% nS = filtersize^2*nC;
% % max_idx is [nB Ph Pw Fo] with value 1..nS with nS=Fw Fh nC
% max_idx = randi([1,nS],1,size(dxcol,1));
% 
% % dout flattened: nB nP having summed by Fo
% % dxcol is: nBnP,nS indexed by max_idx
% dxcol(sub2ind(size(dxcol),1:length(max_idx),max_idx)) = dout(:); 
% dx = munpatcher(dxcol,Sel,size(a));
% 
% squeeze(dx(1,:,:,1))
