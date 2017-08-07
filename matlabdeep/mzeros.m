function r = mzeros(a,t)

if length(a) == 1
    a = [1,a];
end
if nargin == 1
    r = zeros(a);
else
    r = zeros(a,t);
end
    
    