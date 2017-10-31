deftype = DeepOp.setgetDefaultType(double(0));


Fin = 2;
Fout = 3;
w = [1,0,0,0,1,0; 0,0,0,0,0,0;  0,0,0,0,0,0; 0,0,0,0,0,0;0,0,0,0,0,0];
wx = zeros(1,size(w,1),size(w,2),Fin);
wx(1,:,:,1) = w;

W1 = [1,1,1;1,1,1;1,1,1]; 
Wv = zeros(size(W1,1),size(W1,1),Fin,Fout);
Wv(:,:,1,1) = W1;

% x,ksize,strides,pad
x = Variable('x',wx);
W = Variable('W',Wv);
q = Conv2dOp(x,W,[1,1,1,1],'SAME');
q.evalshape();
r = q.eval(); % B=1 P=
Q = mallindex(size(r));
q.grad(Q);
x.xgrad