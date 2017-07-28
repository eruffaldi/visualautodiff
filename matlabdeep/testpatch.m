

a = mallindex([1,28,28,1]);
filtersize = 5; 
padding = (filtersize-1)/2;
stride = 1;
%a = padarray(
%X_col = im2col_indices(X, filtersize, filtersize, padding=padding, stride=stride)

%  k, i, j, out_height, out_width = get_im2col_indices(x.shape, field_height, field_width, padding,
%                               stridex,stridey)

%  cols = x_padded[:, k, i, j]
%  C = x.shape[1]
%  cols = cols.transpose(1, 2, 0).reshape(field_height * field_width * C, -1)
