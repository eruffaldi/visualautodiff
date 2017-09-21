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
  outshape = [out_height out_width];

  if nargout < 2
    return;
  end

  % block repeat means that we reat each digit 
  Kbycolx = blockrepeat0(field_height,field_width);
  if strcmp(mode,'BPKC')
      Kbycol = repmat(Kbycolx, 1, C); % was np.tile(i0,C) along X
      Kbyrow = interrepeat0(field_width,field_height*C);
  elseif strcmp(mode,'BPCK')
      % no action needed
      Kbycol = Kbycolx;
      Kbyrow = interrepeat0(field_width,field_height);
  end  

  % then the macro blocks
  i1 = stridey *  blockrepeat0(out_width,out_height);
  j1 = stridex * interrepeat0(out_height,out_width);
  
  % i1 runs by row while i0 runs by cols: for each we add the offset of the
  % points inside

  % original
  ia = repmat(reshape(Kbycol,[],1),1,numel(i1)) + repmat(reshape(i1,1,[]),numel(Kbycol),1); % EXPANSION 
  ja = repmat(reshape(Kbyrow,[],1),1,numel(j1)) + repmat(reshape(j1,1,[]),numel(Kbyrow),1); % EXPANSION 
    
  nP = out_height*out_width;
     
  if C == 1
    i = ia;
    j = ja;
    k = zeros(size(ia));
  else
      % now deal with the C channel, working in last position BPKC or in
      % pre-last BPCK
      if strcmp(mode,'BPKC')
          % i and j are ready correctly replicated
          k = repmat(0:C-1,field_height*field_width*nP,1);
          i = ia;
          j = ja;
      elseif strcmp(mode,'BPCK')
          % Input: B Ih Iw C
          % we set ijk to scan IhIwC building the manual indexing
          % (sub2ind). 
          % [field_height*field_width*nC,nP]
          k = repmat((0:C-1),field_height*field_width*nP,1);
          nCO = C*field_width*field_height;
          i = reshape(repmat(ia(:)',C,1),nCO,nP);
          j = reshape(repmat(ja(:)',C,1),nCO,nP);
          %k = blockrepeat0(C,nP)'; 
          % k 
      end
end
