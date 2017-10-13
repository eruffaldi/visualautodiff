
function Y_rows_Cout = accummatrix(idx,X_rows_Cin,Cout)
%#codegen
% Gather Matrix

rows = size(X_rows_Cin,1);
Cin = size(X_rows_Cin,2);
nsubs = length(idx);
assert(ismatrix(X_rows_Cin));
assert(nsubs <= Cin);
Y_rows_Cout = zeros([rows,Cout],'like',X_rows_Cin);

if coder.target('MATLAB')
for input_col=1:length(idx)
    itarget_col = idx(input_col);
    if itarget_col >= 1 & itarget_col <= Cout
        Y_rows_Cout(:,itarget_col) = Y_rows_Cout(:,itarget_col) + X_rows_Cin(:,input_col);
    end
end
else
	for input_col=1:length(idx)
	    itarget_col = idx(input_col);
    	if itarget_col >= 1 & itarget_col <= Cout
    		for j=1:size(Y_rows_Cout,1)
	        	Y_rows_Cout(j,itarget_col) = Y_rows_Cout(j,itarget_col) + X_rows_Cin(j,input_col);
	        end
    	end
    end
end

