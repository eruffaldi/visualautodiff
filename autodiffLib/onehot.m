function y = onehot(x,minv,maxv)

%non-codegen full(ind2vec((x+1)))'
%codegen
classes = maxv-minv+1;
y = zeros(length(x),classes);
for I=1:classes
    y(x == I+minv-1,I) = 1;
end
