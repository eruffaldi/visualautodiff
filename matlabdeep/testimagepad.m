% Tests imagepad between Python and Matlab
[poutshape,pk,pi,pj] = imagepadpy(1,[28,28],5,5,[2,2 3 3],[2 2]);
[moutshape,mk,mi,mj] = imagepad(1,[28,28],5,5,[2,2 3 3],[2 2]);

assert(all(poutshape == moutshape),'same output dim');

assert(all(size(pk) == size(mk)),'same dim k');
assert(all(size(pi) == size(mi)),'same dim i');
assert(all(size(pj) == size(mj)),'same dim j');

assert(all(all(pk == mk)),'same k');
assert(all(all(pi == mi)),'same i');
assert(all(all(pj == mj)),'same j');