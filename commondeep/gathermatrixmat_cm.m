function out = gathermatrix(S,A,n)

rows = size(A,1);
cols = size(A,2);
nsubs = length(S);
outrows = n;

assert(nsubs <= outrows);
out = coder.nullcopy(zeros([outrows,cols],'like',A));

for itarget_row=1:nsubs
    input_row = S(itarget_row);
    if input_row > 0
        out(itarget_row,:) =A(input_row,:);
    end
end
if coder.target('MATLAB')
	out(nsubs+1:end,:) = 0;
end
