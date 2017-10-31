
%%
x = Placeholder('float',[-1, 784]);
W = Variable(truncated_normal_gen([784,10],0,0.1,'float'));
b = Variable(0.1*ones([1,10]));
y = AddOp(MatmulOp(x, W),b);

x.set(rand([128,784]));
y.reset();
y.evalshape()
r = y.eval();
y.grad(1);
bg = b.getgrad();
Wg = W.getgrad();

