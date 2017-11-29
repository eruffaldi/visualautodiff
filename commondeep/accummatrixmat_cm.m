
function Y_Rout_cols = accummatrix(idx,X_Rin_cols,Rout)
%#codegen
% Gather Matrix

cols = size(X_Rin_cols,2);
Rin = size(X_Rin_cols,1);
nsubs = length(idx);
assert(ismatrix(X_Rin_cols));
assert(nsubs <= Rin);
Y_Rout_cols = zeros([Rout,cols],'like',X_Rin_cols);

if coder.target('MATLAB')
    for input_row=1:length(idx)
        itarget_row = idx(input_row);
        if itarget_row >= 1 & itarget_row <= Rout
            Y_Rout_cols(itarget_row,:) = Y_Rout_cols(itarget_row,:) + X_Rin_cols(input_row,:);
        end
    end
else
	for input_row=1:length(idx)
	    itarget_row = idx(input_row);
    	if itarget_row >= 1 & itarget_row <= Rout
    		for j=1:size(Y_Rout_cols,2)
	        	Y_Rout_cols(itarget_row,j) = Y_Rout_cols(itarget_row,j) + X_Rin_cols(input_row,j);
	        end
    	end
    end
end

