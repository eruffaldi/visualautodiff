


ma = mallindex([3,4]);
subs = [1,2,3,3];
r = gathermatrix_cm(int32(subs),ma,length(subs));
r2 = gathermatrixmat_cm(int32(subs),ma,length(subs));

%assert(strcmp(class(r),class(ma)));
assert(all(all(r == r2)));