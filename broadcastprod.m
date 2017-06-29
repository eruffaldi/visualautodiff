function out = generictprod(L,R,innerindexL,innerindexR)
%
% this is the matrix (not tensor product) between two tensors specifying
% the inner index in both 
%
% for fully generic tensor product use tprod or extend it accordingly

sizeLeft = size(L);
sizeRight = size(R);

inputDimL = sizeLeft(innerindexL);
inputDimR = sizeRight(innerindexR);
assert(inputDimL == inputDimR, 'same size');
reorderedA = [setdiff(1:ndims(L),innerindexL),innerindexL]; % moves index rightmost 
reorderedB = [innerindexR, setdiff(1:ndims(R),innerindexR)]; % moves index leftmost

%inverseorderA = zeros(length(reorderedA)-1,1);
%inverseorderA(reorderedA(1:end-1) = 1:(length(reorderedA)-1);

%inverseorderB = zeros(length(reorderedB)-1,1);
%inverseorderB(reorderedB(2:end) = 1:(length(reorderedB)-1);

pL = reshape(permute(L, reorderedA),[],inputDimL); 
pR = reshape(permute(R, reorderedB),inputDimR,[]);

% pL*pR will have [prod(L dims not inner),prod(R dims not inner)]
% we can keep size but expand
outsize = [sizeLeft(reorderedA(1:end-1)) sizeRight(reorderedB(2:end))];

out = reshape(pL*pR,outsize);