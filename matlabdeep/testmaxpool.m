deftype = DeepOp.setgetDefaultType(double(0));


w = [1,0,0,0,1,0; 0,0,0,0,0,0;  0,0,0,0,0,0; 0,0,0,0,0,0;0,0,0,0,0,0];
wx = zeros(1,size(w,1),size(w,2),2);
wx(1,:,:,1) = w;

% x,ksize,strides,pad
x = Variable('x',wx);
q = MaxPoolOp(x,[1,2,2,1],[1,3,4,1],'SAME');
q.evalshape();
r = q.eval(); % B=1 P=
Q = mallindex(size(r));
q.grad(Q);
x.xgrad