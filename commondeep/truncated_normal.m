
function y = truncated_normal(shape,mean,sqstddev,dtype,dtype1)

if nargin < 4
    dtype = class(mean);
end

if nargin < 5
    dtype1 = dtype;
end

if isa(dtype1,'gpuArray')
    dtype1 = classUnderlying(dtype1);
end

v = mrandn(shape,dtype1);
ok = find(v > sqrt(2));
while ~isempty(ok)
    w = mrandn([1,length(ok)],dtype1);
    v(ok) = w;
    ok = find(v > sqrt(2));
end
y = cast(mean + sqstddev*v,'like',dtype);

