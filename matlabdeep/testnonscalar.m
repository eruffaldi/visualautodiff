

x1 = Placeholder('x1',[2,3]);
x2 = Placeholder('x2',[2,3]);

q = VCatOp(x1,x1+x2);

r = q.evalwith({x1,ones(2,3),x2,2*ones(2,3)})
q.evalgrad()
