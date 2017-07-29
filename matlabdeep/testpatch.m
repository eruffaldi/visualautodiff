% TODO: make the new patch/unpatch N Iw Ih C more in line with the W:
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
    % NOT WORKING
    %outpadded(ai1) = outpadded(ai1) + reshape(cols(I,:,:),1,[]);

%% Alternative using the selection matrix
% take i j limited to first C and sized (FH FW QH QW) and build the
% selection matrix using the indices. For avoiding the padding region we
% sum the padding to the index and remove negative and ones >= PH PW
ii = reshape(i(1:(filtersize^2),:) - padding,1,[]);
jj = reshape(j(1:(filtersize^2),:) - padding,1,[]);
n = ii < 0 | jj < 0 | ii >= size(a,1) | jj >= size(a,2);
% use n to mark terminal extra column
ii(n) = size(a,1); 
jj(n) = 0;
kq = ((ii*size(a,2))+jj+1); % column inde
ee = size(a,1)*size(a,2)+1;
%Sel = zeros( numel(ii), ee);
%kq = sub2ind(size(Sel),1:length(k),k);
%Sel(kq) = 1; % mark selector
Sel = sparse(1:length(kq),kq,ones(length(kq),1));
Sel = Sel(:,1:end-1); % remove spurious rightmost
%%
% from Ih Iw C B to   C B Ih Iw then to:  C B, Ih Iw
q = reshape(a,size(a,1)*size(a,2),nB*nC);
sXp = [filtersize,filtersize,outshape(1)*outshape(2),nC,nB];
Xp = reshape(Sel*q,sXp); % extract data and pad automatically
p1 = squeeze(Xp(:,:,1,1,1))
p2 = squeeze(Xp(:,:,2,1,1))
squeeze(a(1:5,1:5,1,1))
%reshape(Sel'

%%
outpadded = ones([nB, nC, filtersize,filtersize,outshape(1),outshape(2)]); % output: hpad wpad channels batches
outpaddedm = reshape(outpadded,nB*nC,[]);
distro = reshape(outpaddedm*Sel,nB,nC,size(a,1),size(a,2)); % [nB,nC,  Ih, Iw]

squeeze(distro(1,1,:,:))


%%
kk = reshape(repmat(k,1,nP),1,[]); % expand to all patches
ii = reshape(i - padding,1,[]);
jj = reshape(j - padding,1,[]);
n = ii < 0 | jj < 0 | ii >= size(a,1) | jj >= size(a,2);
% use n to mark terminal extra column
ii(n) = 0; 
jj(n) = 0;
kk(n) = nC;
kq = (kk*size(a,1)*size(a,2) + ii*size(a,2))+jj+1; % column inde
ee = nC*size(a,1)*size(a,2)+1;
%Sel = zeros( numel(ii), ee);
%kq = sub2ind(size(Sel),1:length(k),k);
%Sel(kq) = 1; % mark selector
Sel = sparse(1:length(kq),kq,ones(length(kq),1));
Sel = Sel(:,1:end-1); % remove spurious rightmost
nnz(Sel)

q = reshape(a,nC*size(a,1)*size(a,2),nB);
sXp = [filtersize,filtersize,outshape(1)*outshape(2),nC,nB];
Xp = reshape(Sel*q,sXp); % extract data and pad automatically
p1 = squeeze(Xp(:,:,1,1,1))
p2 = squeeze(Xp(:,:,2,1,1))
squeeze(a(1:5,1:5,1,1))
%reshape(Sel'


outpadded = ones([nB, nC, filtersize,filtersize,outshape(1),outshape(2)]); % output: hpad wpad channels batches
outpaddedm = reshape(outpadded,nB,[]);
distro = reshape(outpaddedm*Sel,nB,size(a,1),size(a,2),nC); % [nB,Ih, Iw,C]

squeeze(distro(1,:,:,1))

