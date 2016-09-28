%% create
syms u1 u2 real

u = [u1,u2];
x = u1;
y = u2;
f = y/(x*sin(x+y));
f = sin(x+y);
f = x*sin(x+y);
f = [1,2]*[u1,u2]';
f = sqrt(sum([u1,u2].^2));
f = abs(u1+u2);
df = jacobian(f,u);

touvec(f)
touvec(df(1))
touvec(df(2))

%%
disp('Testing')
size(simout.Data)
for I=1:3
    A = simout.Data(:,I);
    B = simout1.Data(:,I);
    An = isnan(A) == 0;
    Bn = isnan(B) == 0;
    Cn = An & Bn;
    norm(A(Cn)-B(Cn))/sum(Cn)
end

