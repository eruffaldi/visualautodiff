


ma = mallindex([3,4]);
subs = [1,2,3,3];
r = gathermatrix(int32(subs),ma,length(subs));

%assert(strcmp(class(r),class(ma)));
%assert(all(all(r == r0)));