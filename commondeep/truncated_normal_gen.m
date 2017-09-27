function r = truncated_normal_gen(shape,mean,stddev,dtype,dtype1)

if nargin < 5
    dtype1 = dtype;
end

%The generated values follow a normal distribution with specified mean and standard deviation, except that values whose magnitude is more than 2 standard deviations from the mean are dropped and re-picked.
mean = cast(mean,'like',dtype1);
stddev = cast(stddev,'like',dtype1);
r = @() truncated_normal(shape,mean,sqrt(stddev),dtype,dtype1);
