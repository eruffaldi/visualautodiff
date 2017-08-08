function [Sel,sXp,outshape,nameddims] = mpatchprepare(NHWCshape,filtersizes,stride,padding,mode)

if length(padding) == 1
    padding = repmat(padding,4,1);
elseif length(padding) == 2
    padding = repmat(padding,2,1);
end
if length(filtersizes == 1)
    filtersizes = [filtersizes,filtersizes];
end
    
nB = NHWCshape(1);
Ih = NHWCshape(2);
Iw = NHWCshape(3);
nC = NHWCshape(4);




[outshape,k,i,j] = imagepad(nC,[Ih,Iw],filtersizes(1),filtersizes(2),padding,stride);
nCO = size(i,1);
nP = size(i,2);
assert(nCO == nC*filtersizes(1)*filtersizes(2),'expected CO');
assert(all(size(i) == size(j)));
assert(size(k,1) == size(i,1));

if strcmp(mode,'BPCK')
    kk = reshape(repmat(0:nC-1,filtersizes(1)*filtersizes(2)*nP,1),1,[]);
    sXp = [nB,nP,nC,filtersizes(1),filtersizes(2)]; % we append the nP
elseif strcmp(mode,'BPKC')
    kk = reshape(repmat(k,nP,1),1,[]); % expand to all patches
    sXp = [nB,nP,filtersizes(1),filtersizes(2),nC]; % we append the nP
end

% we need to swap i and j
ii = reshape(j' - padding(1),1,[]);
jj = reshape(i' - padding(2),1,[]);
n = ii < 0 | jj < 0 | ii >= Ih | jj >= Iw;
% use n to mark terminal extra column
ii(n) = 0; 
jj(n) = 0;
kk(n) = nC; % extra
%Ih,Iw,nC
nameddims = [];

nameddims.B = 1;
nameddims.P = 2;
if strcmp(mode,'BPCK')
    aih = 1;
    aiw = Ih;
    aiC = Iw*Ih;
    nameddims.C = 3;
    nameddims.Fh = 4;
    nameddims.Fw = 5;
    nameddims.K = [4,5];
elseif strcmp(mode,'BPKC')
    aiC = 1;
    aih = nC;
    aiw = Ih*nC;
    nameddims.C = 4;
    nameddims.Fh = 3;
    nameddims.Fw = 4;
    nameddims.K = [3,4];
end
% (kk,ii,jj)
kq = kk*aiC + ii*aih+jj*aiw+1; % column inde
kq(n) = nC*Ih*Iw+1;
Sel = sparse(1:length(kq),kq,ones(length(kq),1));
Sel = Sel(:,1:end-1); % remove spurious rightmost


