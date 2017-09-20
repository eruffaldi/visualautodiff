function out = gathermatrix(S,A,n)

rows = size(A,1);
cols = size(A,2);
nsubs = length(S);
outcols = n;

assert(nsubs <= outcols);
out = zeros([rows,outcols],'like',A);

for itarget_col=1:nsubs
    input_col = S(itarget_col);
    if input_col > 0
        out(:,itarget_col) = A(:,input_col);
    end
end