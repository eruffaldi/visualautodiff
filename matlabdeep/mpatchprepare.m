function [Sel,sXp,outshape] = mpatchprepare(NHWCshape,filtersize,stride,padding)

Ih = NHWCshape(2);
Iw = NHWCshape(3);
nC = NHWCshape(4);

aih = 1;
aiw = Ih;
aiC = Iw*Ih;


[outshape,k,i,j] = imagepad(nC,[Ih,Iw],filtersize,filtersize,padding,stride);
nCO = size(i,1);
nP = size(i,2);
assert(nCO == nC*filtersize*filtersize,'expected CO');
assert(all(size(i) == size(j)));
assert(size(k,1) == size(i,1));

%originally we used k, but due to the fact that we changed layout to : P F
%C we'll use this
%kk = reshape(repmat(k,nP,1),1,[]); % expand to all patches
kk = reshape(repmat(0:nC-1,filtersize*filtersize*nP,1),1,[]);
% we need to swap i and j
ii = reshape(j' - padding,1,[]);
jj = reshape(i' - padding,1,[]);
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

sXp = [0,nP,filtersize,filtersize,nC]; % we append the nP

