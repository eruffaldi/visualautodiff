
nC = 3;
nB = 5;
a = mallindex([10,10,nC,nB]);
filtersize = 5; 
padding = (filtersize-1)/2;
stride = [1,1];
% padarray PADS first two on the left
ad = padarray(a,[padding,padding],0,'both');

%%
[outshape,k,i,j] = imagepad(nC,[size(a,1),size(a,2)],filtersize,filtersize,padding,stride);
nCO = size(i,1);
nP = size(i,2);
assert(nCO == nC*filtersize*filtersize,'expected CO');
assert(all(size(i) == size(j)));
assert(size(k,1) == size(i,1));
%% extract the patches

% patchcount = length(k) = size(i,1) = size(j,1)
% k picks all the channel dimension => broadcast as i j
% i,j are two matrices: patches x (width*height)
% output: [batch,C*field_width*field_height,patches]
cols = zeros(nB,nCO,nP);
rk1 = reshape(repmat(k+1,1,nP),[],1); % expand to all patches
rk2 = reshape(repmat(k+1,nP,1),[],1); % expand to all patches
rk = rk1;
sad = size(ad); 
ad_nextbatch = prod(sad(1:end-1)); % increment for every patch
ai1 = sub2ind(size(ad),j(:)+1,i(:)+1,rk,ones(numel(i),1)); % first batch
for I=1:sad(end)
    cols(I,:,:) = reshape(ad(ai1),size(i)); % patches
    ai1 = ai1 + ad_nextbatch;
end
% test picking 
C=2;
B=3; 
P=2;
PAH = 2; % patches have stride 1
PAW = 1;
q = reshape(cols(B,:,P),[filtersize,filtersize,nC]); % one patch
q(:,:,C) == ad(PAH:PAH+filtersize-1,PAW:PAW+filtersize-1,C,B) % topleft manuallyq

%% test reassembly common to conv2D and 
% dX = col2im_indices(dX_col, X.shape, h_filter, w_filter, padding=padding, stride=stride)
outpadded = zeros(size(ad)); % output: hpad wpad channels batches
in = cols; % input: convspace,patches*batches => convspace, patches, batches
% increment outpadded at location ai1 iterating by batch 
for I=1:sad(end)
    % ISSUE
    outpadded(ai1) = outpadded(ai1) + reshape(cols(I,:,:),1,[]);
    ai1 = ai1 + ad_nextbatch;
end

