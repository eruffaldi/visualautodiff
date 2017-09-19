function Y = accummatrix(idx,X_B_IC,outcols)

rows = size(X_B_IC,1);
cols = size(X_B_IC,2);
nsubs = length(idx);
assert(nsubs <= cols);
Y = zeros([rows,outcols],'like',X);

for input_cols=1:length(idx)
    itarget_col = idx(input_cols);
    if itarget_col >= 1 & itarget_col <= outcols
        Y(:,itarget_col) = Y(:,itarget_col) + X(:,input_cols);
    end
end

