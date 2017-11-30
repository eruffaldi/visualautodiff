

A = rand(2,3,10);
B = rand(10,16);
iA= 3;
iB= 1;

A = rand(1,10,3);
B = rand(10,16);
iA = 2;
iB = 1;

out1 = broadcastprodT(A,B,iA,iB);
size(out1)

out2 = broadcastprod(A,B,iA,iB);
assert(ndims(out1) == ndims(out2),'same dims');
assert(all(size(out2)==size(out1)),'same size');
sum(reshape(out1-out2,1,[]))