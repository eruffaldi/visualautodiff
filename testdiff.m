X = sym('x',[3,2]);
assume(X,'real');
Y = sym('y',[2,4]);
assume(Y,'real');
Z = X*Y;
JX = jacobian(Z(:),X(:)); % equivalent to (3,4) (3,2) so we sum up the first dim
Jx = reshape(sum(JX,1),size(X));
%EQUIVTO repmat(reshape(sum(Y,2),1,size(Y,1)),size(X,1),1)


JY = jacobian(Z(:),Y(:)); % equivalent to (3,4) (3,2) so we sum up the first dim
Jy = reshape(sum(JY,1),size(Y));
%EQUIVTO repmat(reshape(sum(X,1),size(X,2),1),1,size(Y,2))
