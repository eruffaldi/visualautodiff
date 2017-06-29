function y = ematrix2tensor(x,fullsize,inner1,inner2)

% [] inner1 inner2 => original
assert(ndims(x) == 3);
assert(size(x,2) == fullsize(inner1));
assert(size(x,3) == fullsize(inner2));

sizeLeft = size(x);
reorderedA = [setdiff(1:length(L),[inner1,inner2]),inner1,inner2]; % moves index rightmost 
reorederdSize = sizeLeft(reorderedA);

if inner1 == length(fullsize)-1 & inner2 == length(fullsize)-2
    y = reshape(x,reorderedSize);
else
    inverseorderA = zeros(length(reorderedA),1);
    inverseorderA(reorderedA) = 1:length(reorderedA);

    y = permute(reshape(x, reorederdSize),inverseorderA);
end