function r = truncated_normal(shape,mean,stddev,dtype)

%The generated values follow a normal distribution with specified mean and standard deviation, except that values whose magnitude is more than 2 standard deviations from the mean are dropped and re-picked.

r = @() truncated_normalfx(shape,mean,sqrt(stddev),dtype);

function y = truncated_normalfx(shape,mean,sqstddev,dtype)

v = randn(shape);
ok = find(v > sqrt(2));
while ~isempty(ok)
    w = randn([1,length(ok)]);
    v(ok) = w;
    ok = find(v > sqrt(2));
end
y = mean + sqstddev*v;

