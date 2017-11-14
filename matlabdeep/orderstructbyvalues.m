function s = orderstructbyvalues(x)

[~,ori] = sort(structfun(@(y) y,x));
ff = fieldnames(x);
s = orderfields(x,ff(ori));