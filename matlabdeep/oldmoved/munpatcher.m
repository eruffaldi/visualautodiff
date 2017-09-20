% Reverses the input data from patches aggregating
%
% Xp = input patches = [N x P]
% Sel = selector = [P x Q]
%
% Output
%   X = [N x Q]
%
% Where
%   Q = input space
function X = munpatcher(Xp,Sel,NHWCshapex)

NHWCshape = ones(1,4);
NHWCshape(1:numel(NHWCshapex))=NHWCshapex;
nB = NHWCshape(1);
Ih = NHWCshape(2);
Iw = NHWCshape(3);
nC = NHWCshape(4);

Xpm = reshape(Xp,nB,[]); % keep on the left

%sparse Approach => no GPU, only double
%w = double(Xpm)*Sel.A;

%accumarray Approach: notpossibly because value is vector => loops
%w = accumarray(Sel.kq,Xpm,[size(Xpm,1),size(Sel.A,2)]);
if isa(Xpm,'gpuArray')
    w = accummatrix(Sel.pickidx,gather(Xpm),size(Sel.A,2));
else
    w = accummatrix(Sel.pickidx,Xpm,size(Sel.A,2));
end

X = reshape(w,nB,Ih,Iw,nC); % product is Nx(Ih Iw C)

if isa(Xpm,'gpuArray')
    X =  cast(X,'like',Xpm);
end
