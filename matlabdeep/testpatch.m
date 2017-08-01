% TODO: make the new patch/unpatch N Iw Ih C more in line with the W:
% TensorFlow supports NHWC (TensorFlow default) and NCHW (cuDNN default)
nC = 3;
nB = 5;
Ih = 10;
Iw = 10;
a = mallindex([nB,Ih,Iw,nC]);
filtersize = 5; 
padding = (filtersize-1)/2;
stride = [1,1];
sa = size(a);
a1 = a(1,:,:,:); % Ih runs faster
aih = sub2ind(sa(2:end),2,1,1)-1;
aiw = sub2ind(sa(2:end),1,2,1)-1;
aiC = sub2ind(sa(2:end),1,1,2)-1;


%%
[outshape,k,i,j] = imagepad(nC,[Ih,Iw],filtersize,filtersize,padding,stride);
nCO = size(i,1);
nP = size(i,2);
assert(nCO == nC*filtersize*filtersize,'expected CO');
assert(all(size(i) == size(j)));
assert(size(k,1) == size(i,1));


%%
kk = reshape(repmat(k,1,nP),1,[]); % expand to all patches
ii = reshape(i - padding,1,[]);
jj = reshape(j - padding,1,[]);
n = ii < 0 | jj < 0 | ii >= Ih | jj >= Iw;
% use n to mark terminal extra column
ii(n) = 0; 
jj(n) = 0;
kk(n) = nC; % extra
%Ih,Iw,nC
kq = (kk*aiC + ii*aih)+jj*aiw+1; % column inde
kq(n) = nC*Ih*Iw+1;
Sel = sparse(1:length(kq),kq,ones(length(kq),1));
Sel = Sel(:,1:end-1); % remove spurious rightmost
nnz(Sel)
size(Sel)

as = reshape(a,nB,nC*Ih*Iw);
as1 = reshape(as(1,:),Ih,Iw,nC);
as1(1:5,1:5,1) % ok

sXp = [nB,filtersize,filtersize,nC,nP]; % we append the nP
Xp = reshape(as*Sel',sXp); % extract data and pad automatically
p1 = squeeze(Xp(1,:,:,1,1))
p2 = squeeze(Xp(1,:,:,1,2))
squeeze(a(1,1:5,1:5,1))
%reshape(Sel'

%%
outpadded = ones(sXp); % one each
outpaddedm = reshape(outpadded,nB,[]); % keep on the left
distro = reshape(outpaddedm*Sel,nB,Ih,Iw,nC); % product is Nx(Ih Iw C)
squeeze(distro(1,:,:,1))



