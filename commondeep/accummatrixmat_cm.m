
function Y_rows_Rout = accummatrix(idx,X_Rin_cols,Rout)
%#codegen
% Gather Matrix

cols = size(X_Rin_cols,1);
Rin = size(X_Rin_cols,2);
nsubs = length(idx);
assert(ismatrix(X_Rin_cols));
assert(nsubs <= Rin);
Y_Rout_rows = zeros([Rout,cols],'like',X_Rin_cols);

if coder.target('MATLAB')
    for input_row=1:length(idx)
        itarget_row = idx(input_row);
        if itarget_row >= 1 & itarget_row <= Rout
            Y_rows_Rout(itarget_row,:) = Y_rows_Rout(itarget_row,:) + X_Rin_cols(input_row,:);
        end
    end
else
	for input_row=1:length(idx)
	    itarget_row = idx(input_row);
    	if itarget_row >= 1 & itarget_row <= Rout
    		for j=1:size(Y_rows_Rout,2)
	        	Y_rows_Rout(itarget_row,j) = Y_rows_Rout(itarget_row,j) + X_Rin_cols(input_row,j);
	        end
    	end
    end
end

