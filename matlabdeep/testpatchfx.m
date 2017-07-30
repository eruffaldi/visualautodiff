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

W = mones([filtersize,filtersize,nC,nFo]);
[Sel,sXp,outshape] = mpatchprepare(size(a),5,[1 1],2); % N independent
% [nB,Fh,Fw,nC,nP]
Xp = mpatcher(a,Sel,sXp); % [nB , Fh Fw nC patches]
Y = reshape(reshape(permute(Xp,[1,5,2,3,4]),nB*sXp(end),[])*reshape(W,[],nFo),nB,outshape(1),outshape(2),nFo);

aX = munpatcher(ones(size(Xp)),Sel,size(a));
p1 = squeeze(Xp(1,:,:,1,1)) % should have only 2nd and 3d moving
p2 = squeeze(Xp(1,:,:,1,2))
squeeze(a(1,1:5,1:5,1)) 


squeeze(aX(1,:,:,1)) % should be 25 in center, 9 in corner

%% The Max Pool requires a different treatment
%
dout = sum(mones(size(Y)),4); % N Ph Pw Fo incoming => N Ph Pw
w = reshape(permute(Xp,[1,5,2,3,4]),nB*sXp(end),[]);
dxcol = mzeros(size(w)); % [nB*nP, nS]
nS = filtersize^2*nC;
% max_idx is [nB Ph Pw Fo] with value 1..nS with nS=Fw Fh nC
max_idx = randi([1,nS],1,size(dxcol,1));

% dout flattened: nB nP having summed by Fo
% dxcol is: nBnP,nS indexed by max_idx
dxcol(sub2ind(size(dxcol),1:length(max_idx),max_idx)) = dout(:); 
dx = munpatcher(dxcol,Sel,size(a));

squeeze(dx(1,:,:,1))
