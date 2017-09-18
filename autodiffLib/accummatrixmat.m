function Y = accummatrix(idx,X,outcols)

rows = size(X,1);
cols = size(X,2);
nsubs = length(S);
assert(nsubs <= cols);
Y = zeros([rows,outcols],'like',X);

for input_cols=1:length(idx)
    itarget_col = idx(input_cols);
    if itarget_col >= 1 & itarget_col <= outcols
        Y(:,itarget_col) = Y(:,itarget_col) + X(:,input_cols);
    end
end

