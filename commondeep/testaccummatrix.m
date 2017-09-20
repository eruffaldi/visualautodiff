

ma = [1,2,3,10;4,5,6,20;7,8,9,30];
subs = [1,2,3,3];
r = accummatrix(int32(subs),ma,3);
r2 = accummatrixmat(int32(subs),ma,3);
r0 =    [ 1     2    13
     4     5    26
     7     8    39];

assert(strcmp(class(r),class(ma)));
assert(all(all(r == r0)));
assert(all(all(r2 == r0)));