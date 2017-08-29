% like size(a) but exploits the fact that size(a,J) = 1 for J > ndims(a)
function s = msize(a,exdims)

s = [size(a), ones(1,exdims-ndims(a))];
