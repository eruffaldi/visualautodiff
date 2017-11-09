function [Sel,sXp,outshape,nameddims] = mpatchprepare(NHWC_CWHN_shape,filtersizesa,sizeout,stride,paddinga,mode,colmajor)

if length(paddinga) == 1
    padding = repmat(paddinga,4,1);
elseif length(paddinga) == 2
    padding = repmat(paddinga,2,1);
else
    padding = paddinga;
end
if length(filtersizesa == 1)
    filtersizes = [filtersizesa,filtersizesa];
else
    filtersizes = filtersizesa;
end
% ensure length 4
if colmajor 
    CWHNshape = ones(1,4);
    CWHNshape(1:numel(NHWC_CWHN_shape)) = NHWC_CWHN_shape;
    nB = CWHNshape(4);
    Ih = CWHNshape(3);
    Iw = CWHNshape(2);
    nC = CWHNshape(1);
else
    NHWCshape = ones(1,4);
    NHWCshape(1:numel(NHWC_CWHN_shape)) = NHWC_CWHN_shape;
    nB = NHWCshape(1);
    Ih = NHWCshape(2);
    Iw = NHWCshape(3);
    nC = NHWCshape(4);
end


[outshape,k,i,j] = imagepad(nC,[Ih,Iw],filtersizes(1),filtersizes(2),sizeout,padding,stride,mode,colmajor);
if colmajor
    nCO = size(i,1);
    nP = size(i,2);
else
    nCO = size(i,1);
    nP = size(i,2);
end
assert(nCO == nC*filtersizes(1)*filtersizes(2),'expected CO');
assert(all(size(i) == size(j)));
assert(numel(k) == numel(i))


if strcmp(mode,'BPKC')
    % iterate the nC (0-based) by all 
    %kk = reshape(repmat(0:nC-1,filtersizes(1)*filtersizes(2)*nP,1),1,[]);
    sXp = [nB,nP,filtersizes(1),filtersizes(2),nC]; % we append the nP
elseif strcmp(mode,'BPCK')
    %kk = reshape(repmat(k,nP,1),1,[]); % C runs faster
    sXp = [nB,nP,nC,filtersizes(1),filtersizes(2)]; % we append the nP
elseif strcmp(mode,'KCPB')
    sXp = [filtersizes(2),filtersizes(1),nC,nP,nB]; % we append the nP
elseif strcmp(mode,'CKPB')
    sXp = [nC,filtersizes(2),filtersizes(1),nP,nB]; % we append the nP
end

% shift selector by topleft padding and mark all not valid indices as extra
% column
id0 = reshape(j' - padding(1),1,[]);
id1 = reshape(i' - padding(2),1,[]);
id2 = reshape(k,1,[]);

% identify out of shape (due to padding) and remove them marking as special
% extra item that will be removed from the sparse matrix
n = id0 < 0 | id1 < 0 | id0 >= Ih | id1 >= Iw;
if colmajor
id0(n) = Ih; 
id1(n) = 0;
id2(n) = 0; % extra
else
id0(n) = 0; 
id1(n) = 0;
id2(n) = nC; % extra
end
nameddims = struct();

% TODO: automate this
if strcmp(mode,'BPCK')
    nameddims.B = 1;
    nameddims.P = 2;
    nameddims.C = 3;
    nameddims.Fh = 4;
    nameddims.Fw = 5;
    nameddims.K = [4,5];
elseif strcmp(mode,'BPKC')
    nameddims.B = 1;
    nameddims.P = 2;
    nameddims.Fh = 3;
    nameddims.Fw = 4;
    nameddims.K = [3,4];
    nameddims.C = 5;
elseif strcmp(mode,'KCPB')
    nameddims.Fh = 2;
    nameddims.Fw = 1;
    nameddims.K = [2,1];
    nameddims.C = 3;
    nameddims.P = 4;
    nameddims.B = 5;
elseif strcmp(mode,'CKPB')
    nameddims.C = 1;
    nameddims.K = [3,2];
    nameddims.P = 4;
    nameddims.B = 5;
    nameddims.Fh = 3;
    nameddims.Fw = 2;
end

% build indexing inside the input that is: B Ih Iw C
if colmajor
    kq = sub2ind([nC,Iw,Ih+1],id2+1,id1+1,id0+1); 
else
    kq = sub2ind([Ih,Iw,nC+1],id0+1,id1+1,id2+1); 
end
if sum(n) > 0
    kq(n) = 0;  % mark as 0 for output
end
Selx = [];
% given kq construct the equivalent of the selector of sparse matrix
% that is:
%   slotsfor = full(sum(Selx,1))
%   indexes = cumsum(slotsfor)
%   find(kq == 1) ... each or find(Sel(:,I))
%   find(Sel(I,:)) has 0 or 1 element
%   find(Sel(:,I)) has 1 to patchsize elements such as slotsfor
Sel = struct();
Sel.A = Selx;
Sel.pickidx = int32(kq);
Sel.sXp = sXp;
Sel.outshape = outshape;
if colmajor
Sel.gather = @gathermatrix_cm;
Sel.accum = @accummatrix_cm;
else
Sel.gather = @gathermatrix_rm;
Sel.accum = @accummatrix_rm;
end


