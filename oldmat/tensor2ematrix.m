function y = tensor2ematrix(x,inner1,inner2)

% A1...AN => [] A(inner1) A(inner2)
sizeLeft = size(x);
reorderedA = [setdiff(1:ndims(L),[inner1,inner2]),inner1,inner2]; % moves index rightmost 
if inner1 == ndims(x)-1 & inner2 == ndims(x)
    y = reshape(x,[],sizeLeft(inner1),sizeLeft(inner2)) ;
else
    y = reshape(permute(x, reorderedA),[],sizeLeft(inner1),sizeLeft(inner2)) ;
end
