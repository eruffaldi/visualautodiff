a = sym('a',[3,3]);
b = sym('b',[3,3]);
y = a.*b;

JY = sym('JY',[1,3*3]); % tensormode
JA = JY*jacobian(y(:),a(:)); 
JB = JY*jacobian(y(:),b(:));

JYs = sym('JY',[3,3]); % scalarmode
JAs = JYs.*reshape(diag(jacobian(y(:),a(:))),3,3);
JBs = JYs.*reshape(diag(jacobian(y(:),b(:))),3,3);
