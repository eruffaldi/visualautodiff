% [k,i,j] = imagepad(1,[28,28],5,5,0,[2,2])

% padding is 4d: top left bottom right
% stride is  2d
% k is NOT neeed
function [outshape,k,i,j] = imagepad(C,xshape,field_height,field_width,padding,stride,mode)

  H = xshape(1);
  W = xshape(2);
  stridey = stride(1);
  stridex = stride(2);

  % np.repeat(np.arange(A), B) =>  as 0000 1111 2222 ..
  % np.tile(np.arange(A), B))  =>  as 012 012 012
  blockrepeat0= @(A,B) reshape(repmat((1:A)-1,B,1),1,[]);
  interrepeat0= @(A,B) reshape(repmat((1:A)-1,1,B),1,[]);
  
  assert (mod(H + padding(1)+padding(3) - field_height,stridey) == 0,'alignment of pad and stride-size in H');
  assert (mod(W + padding(2)+padding(4) - field_width,  stridex) == 0,'alignment of pad and stride-size in W');
  out_height = (H + padding(1)+padding(3) - field_height) / stridey + 1;
  out_width = (W + padding(2)+padding(4) - field_width) / stridex+ 1;

  i0 = blockrepeat0(field_height,field_width);
  if strcmp(mode,'BPKC')
      i0 = repmat(i0, 1, C); % was np.tile(i0,C) along X
  elseif strcmp(mode,'BPCK')
      % no action needed
  end
  i1 = stridey * blockrepeat0(out_height, out_width);
  if strcmp(mode,'BPKC')
      j0 = interrepeat0(field_width,field_height*C);
  elseif strcmp(mode,'BPCK')
      j0 = interrepeat0(field_width,field_height);
  end
  j1 = stridex * interrepeat0(out_width, out_height);
  i = repmat(reshape(i0,[],1),1,numel(i1)) + repmat(reshape(i1,1,[]),numel(i0),1); % EXPANSION 
  j = repmat(reshape(j0,[],1),1,numel(j1)) + repmat(reshape(j1,1,[]),numel(i0),1); % EXPANSION 
    
  nP = out_height*out_width;
  outshape = [out_height;out_width];
  if strcmp(mode,'BPKC')
      % i and j are ready correctly replicated
      k = repmat(0:C-1,field_height*field_width*nP,1);
      
  elseif strcmp(mode,'BPCK')
      % replicate K 
      % [field_height*field_width*nC,nP]
      k = repmat((0:C-1)',1,field_height*field_width*nP);
      nCO = C*field_width*field_height;
      i = reshape(repmat(i(:)',C,1),nCO,nP);
      j = reshape(repmat(j(:)',C,1),nCO,nP);
      %k = blockrepeat0(C,nP)'; 
      % k 
  end
