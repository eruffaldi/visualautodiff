function [Sel,sXp,outshape] = mpatchprepare(NHWCshape,filtersizes,stride,padding)

if length(padding) == 1
    padding = repmat(padding,4,1);
elseif length(padding) == 2
    padding = repmat(padding,2,1);
end
    
Ih = NHWCshape(2);
Iw = NHWCshape(3);
nC = NHWCshape(4);

aih = 1;
aiw = Ih;
aiC = Iw*Ih;


[outshape,k,i,j] = imagepad(nC,[Ih,Iw],filtersizes(1),filtersizes(2),padding,stride);
nCO = size(i,1);
nP = size(i,2);
assert(nCO == nC*filtersizes(1)*filtersizes(2),'expected CO');
assert(all(size(i) == size(j)));
assert(size(k,1) == size(i,1));

%originally we used k, but due to the fact that we changed layout to : P F
%C we'll use this
%kk = reshape(repmat(k,nP,1),1,[]); % expand to all patches
kk = reshape(repmat(0:nC-1,filtersizes(1)*filtersizes(2)*nP,1),1,[]);
% we need to swap i and j
ii = reshape(j' - padding(1),1,[]);
jj = reshape(i' - padding(2),1,[]);
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

sXp = [0,nP,filtersizes(1),filtersizes(2),nC]; % we append the nP

