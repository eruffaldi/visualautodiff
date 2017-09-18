function [Sel,sXp,outshape,nameddims] = mpatchprepare(NHWCshape,xfiltersizes,stride,xpadding,mode)

if length(xpadding) == 1
    padding = repmat(xpadding,4,1);
elseif length(xpadding) == 2
    padding = repmat(xpadding,2,1);
end
if length(xfiltersizes == 1)
    filtersizes = [xfiltersizes,xfiltersizes];
else
    filtersizes = xfiltersizes;
end
    
nB = NHWCshape(1);
Ih = NHWCshape(2);
Iw = NHWCshape(3);
nC = NHWCshape(4);




[outshape,k,i,j] = imagepad(nC,[Ih,Iw],filtersizes(1),filtersizes(2),padding,stride,mode);
nCO = size(i,1);
nP = size(i,2);
assert(nCO == nC*filtersizes(1)*filtersizes(2),'expected CO');
assert(all(size(i) == size(j)));
assert(numel(k) == numel(i))

kk = reshape(k,1,[]);

if strcmp(mode,'BPKC')
    % iterate the nC (0-based) by all 
    %kk = reshape(repmat(0:nC-1,filtersizes(1)*filtersizes(2)*nP,1),1,[]);
    sXp = [nB,nP,filtersizes(1),filtersizes(2),nC]; % we append the nP
elseif strcmp(mode,'BPCK')
    %kk = reshape(repmat(k,nP,1),1,[]); % C runs faster
    sXp = [nB,nP,nC,filtersizes(1),filtersizes(2)]; % we append the nP
end

% shift selector by topleft padding and mark all not valid indices as extra
% column
ii = reshape(j' - padding(1),1,[]);
jj = reshape(i' - padding(2),1,[]);

% identify out of shape (due to padding) and remove them marking as special
% extra item that will be removed from the sparse matrix
n = ii < 0 | jj < 0 | ii >= Ih | jj >= Iw;
ii(n) = 0; 
jj(n) = 0;
kk(n) = nC; % extra
%nameddims = [];

nameddims.B = 1;
nameddims.P = 2;
if strcmp(mode,'BPCK')
    nameddims.C = 3;
    nameddims.Fh = 4;
    nameddims.Fw = 5;
    nameddims.K = [4,5];
elseif strcmp(mode,'BPKC')
    nameddims.C = 5;
    nameddims.Fh = 3;
    nameddims.Fw = 4;
    nameddims.K = [3,4];
end
%withsparse = coder.extrinsic('exist')';

if 1==1
    kq = sub2ind([Ih,Iw,nC+1],ii+1,jj+1,kk+1); 
    %extrakq = Iw*Ih+1; % this marks the kq that is outside
    if 0==1
        Selx = sparse(1:length(kq),kq,true(length(kq),1));
        if sum(n) > 0
            Selx = Selx(:,1:end-1); % remove spurious rightmost
            kq(n) = 0;  % mark as 0 for output
        end
    else
        if sum(n) > 0
            kq(n) = 0;  % mark as 0 for output
        end
        Selx = [];
    end
    % given kq construct the equivalent of the selector of sparse matrix
    % that is:
    %   slotsfor = full(sum(Selx,1))
    %   indexes = cumsum(slotsfor)
    %   find(kq == 1) ... each or find(Sel(:,I))
    %   find(Sel(I,:)) has 0 or 1 element
    %   find(Sel(:,I)) has 1 to patchsize elements such as slotsfor
    Sel.A = Selx;
    Sel.pickidx = int32(kq);
    Sel.sXp = sXp;
    Sel.outshape = outshape;
else
    % manually expressing (Ih,Iw,C+1)
    aiC = Ih*Iw;
    aih = 1;
    aiw = Ih;
    % (ii,jj,kk) selects 0-based into IC
    kq = kk*aiC + ii*aih + jj*aiw + 1; % column inde
    kq(n) = nC*Ih*Iw+1; % do we need this? NO
    if 0==1 %exist('sparse','builtin')
        Sel = sparse(1:length(kq),kq,ones(length(kq),1)); 
        Sel = Sel(:,1:end-1); % remove spurious rightmost
    else
        Sel = [];
    end
end


