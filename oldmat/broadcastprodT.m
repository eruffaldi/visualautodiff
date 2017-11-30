function out = generictprod(L,R,innerindexL,innerindexR)

sizeLeft = size(L);
sizeRight = size(R);

outL = 1:(length(sizeLeft)-1);
if innerindexL == 1
    outL = [-1 outL];
else
    outL = [outL(1:innerindexL-1) -1 outL(innerindexL:end)];
end

outR = (1:(length(sizeRight)-1)) + (length(sizeLeft)-1);
if innerindexR == 1
    outR = [-1 outR];
else
    outR = [outR(1:innerindexR-1) -1 outL(innerindexR:end)];
end

out = tprod(L,outL,R,outR);
