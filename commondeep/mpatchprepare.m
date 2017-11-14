function [Sel,outshape,nameddims] = mpatchprepare(inputmode,inputshape,filtersizesa,sizeout,stride,paddinga,outputmode,colmajor)
mode = outputmode;
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
inshape = ones(1,4);
inshape(1:numel(inputshape)) = inputshape;

inputform = string2struct(inputmode);
outputform = string2struct(outputmode);

nB = inputshape(inputform.B);
nC = inputshape(inputform.C);
Ih = inputshape(inputform.H);
Iw = inputshape(inputform.W);
[outshape,outshapegroup,iH,iW,iC] = imagepad(inputform,outputform,inputshape,filtersizes(1),filtersizes(2),padding,stride,colmajor);

assert(isempty(iH) == 0);
assert(isempty(iW) == 0);
assert(isempty(iC) == 0);

nameddims = string2struct(mode);

idH = reshape(iH - padding(1),1,[]);
idW = reshape(iW - padding(2),1,[]);
idC = reshape(iC,1,[]);

% identify out of shape (due to padding) and remove them marking as special
% extra item that will be removed from the sparse matrix
n = idW < 0 | iH < 0 | idH >= Ih | idW >= Iw;
if colmajor
idH(n) = Ih; % last column (except Batch)
idW(n) = 0;
idC(n) = 0; % extra
else
idH(n) = 0; 
idW(n) = 0;
idC(n) = nC; % last column
end


% build indexing inside the input that is: B Ih Iw C
if colmajor
    kq = sub2ind([nC,Iw,Ih+1],iC+1,iW+1,iH+1); 
else
    kq = sub2ind([Ih,Iw,nC+1],iH+1,iW+1,iC+1); 
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
Sel.outshape = outshape;
Sel.outshapegroup = outshapegroup;
if colmajor
Sel.gather = @gathermatrix_cm;
Sel.accum = @accummatrix_cm;
else
Sel.gather = @gathermatrix_rm;
Sel.accum = @accummatrix_rm;
end


