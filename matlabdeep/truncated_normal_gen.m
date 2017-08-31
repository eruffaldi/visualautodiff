function r = truncated_normal(shape,mean,stddev,dtype,dtype1)

if nargin < 5
    dtype1 = dtype;
end

%The generated values follow a normal distribution with specified mean and standard deviation, except that values whose magnitude is more than 2 standard deviations from the mean are dropped and re-picked.
mean = cast(mean,'like',dtype1);
stddev = cast(stddev,'like',dtype1);
r = @() truncated_normalfx(shape,mean,sqrt(stddev),dtype,dtype1);

function y = truncated_normalfx(shape,mean,sqstddev,dtype,dtype1)

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

