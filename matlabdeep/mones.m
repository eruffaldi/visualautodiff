function r = mones(a,t)

if length(a) == 1
    a = [1,a];
end
if nargin == 1
    r = ones(a);
else
    r = ones(a,t);
end