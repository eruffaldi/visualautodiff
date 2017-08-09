%% Tests the: mpatchprepare, mpatcher, munpatcher
%
% Convolution uses BPKC because works on KC
% Max uses BPCK because works only on K
nB = 6;
nC = 3;
Ih = 10;
Iw = 10;
nFo = 2;
a = mallindex([nB,Ih,Iw,nC]);
filtersize = 5; 
padding = 0; % (filtersize-1)/2;
stride = [1,1];

mode = 'BPCK';
mode = 'BPKC'; %OK
[Sel_PX_IC,sXp,outshape,nameddims] = mpatchprepare(size(a),filtersize,[1 1],2,mode); % N independent
% Sel: PKC_IC or PCK_IC

Xp = mpatcher(a,Sel_PX_IC,sXp); % extracted patch
assert(size(Xp,1) == nB);
assert(size(Xp,2) == prod(outshape));
assert(size(Xp,nameddims.C) == nC);
assert(size(Xp,nameddims.K(1)) == filtersize);
assert(size(Xp,nameddims.K(2)) == filtersize);
% Xp: B_P_C_Kh_Kw or B_P_Kh_Kw_C


iC = 2;
if nameddims.C == 5
    p1 = squeeze(Xp(1,1,:,:,iC)) % should have only 2nd and 3d moving
    p2 = squeeze(Xp(1,2,:,:,iC)) % should appear as top left
    squeeze(a(1,1:filtersize,1:filtersize,1)) 
    W = mones([filtersize,filtersize,nC,nFo]);
    % test product
    assert(nameddims.K(2) ==nameddims.C-1)
    Y = reshape(reshape(Xp,[], sXp(nameddims.K(1))*sXp(nameddims.K(2))*sXp(nameddims.C))*reshape(W,[],nFo),nB,outshape(1),outshape(2),nFo);

else
    p1 = squeeze(Xp(1,1,iC,:,:)) % should have only 2nd and 3d moving
    p2 = squeeze(Xp(1,2,iC,:,:)) % should appear as top left
    squeeze(a(1,1:5,1:5,1)) 
    
end
    
% contributions from every patch to the original image
aX = munpatcher(ones(size(Xp)),Sel_PX_IC,size(a));
aX_B1_C1 = squeeze(aX(1,:,:,1)) % should be 25 in center, 9 in corner



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
