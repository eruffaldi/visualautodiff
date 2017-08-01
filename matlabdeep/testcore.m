%%
A = sym('a',[2, 3]);
B = sym('b',[3, 4]);

C = mean(reshape(A*B,[],1));

dCA = reshape(jacobian(C(:),A(:)),size(A));
dCB = reshape(jacobian(C(:),B(:)),size(B));

%%

A = sym('a',[2, 3]);
C = mean(A(:));
dCA = jacobian(C,A(:));
