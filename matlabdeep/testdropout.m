
keep_prob = Placeholder('float',1);

X = Variable('X',mallindex([3,4]));

d = DropoutOp(X, keep_prob);

y = d.evalwith({X,mallindex(X.xshape),keep_prob,0.2})
d.grad(1)
X.xgrad