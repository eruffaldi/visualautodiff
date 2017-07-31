% [k,i,j] = imagepad(1,[28,28],5,5,0,[2,2])

% padding is 4d: top left bottom right
% stride is  2d
% k is NOT neeed
function [outshape,k,i,j] = imagepad(C,xshape,field_height,field_width,padding,stride)

  H = xshape(1);
  W = xshape(2);
  stridey = stride(1);
  stridex = stride(2);

  tile = @repmat;
  
  assert (mod(H + padding(1)+padding(3) - field_height,stridey) == 0,'alignment of pad and stride-size in H');
  assert (mod(W + padding(2)+padding(4) - field_width,  stridex) == 0,'alignment of pad and stride-size in W');
  out_height = (H + padding(1)+padding(3) - field_height) / stridey + 1;
  out_width = (W + padding(2)+padding(4) - field_width) / stridex+ 1;

  i0 = repmat(1:field_height, field_width,1); 
  i0 = tile(i0, C);
  i1 = stridey * repmat(1:out_height, out_width);
  j0 = tile(1:field_width, field_height * C);
  j1 = stridex * tile(1:out_width, out_height);
  i = reshape(i0,[],1) + reshape(i1,1,[]);
  j = reshape(j0,[],1) + reshape(j1,1,[]);
  
  k = reshape(repmat(1:C, field_height * field_width),[],1);
    
  i = i';
  j = j';
  k = k';
  outshape = [out_height;out_width];
