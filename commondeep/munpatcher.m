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
function X = munpatcher(Xp,Sel,NHWCshape,SelA)

nB = NHWCshape(1);
Ih = NHWCshape(2);
Iw = NHWCshape(3);
if length(NHWCshape) == 3
    nC = 1;
else
    nC = NHWCshape(4);
end

Xpm = reshape(Xp,nB,[]); % keep on the left

%sparse Approach => no GPU, only double
%w = double(Xpm)*Sel.A;

%accumarray Approach: notpossibly because value is vector => loops
%w = accumarray(Sel.kq,Xpm,[size(Xpm,1),size(Sel.A,2)]);
if isa(Xpm,'gpuArray')
    w = accummatrix(Sel.pickidx,gather(Xpm),size(Sel.A,2));
else
    if isstruct(Sel)
        f = Sel.accum;
        w = f(Sel.pickidx,Xpm,size(Sel.A,2));
    else
        w = accummatrixmat(Sel,Xpm,SelA);
    end
        
end

X = reshape(w,nB,Ih,Iw,nC); % product is Nx(Ih Iw C)

if isa(Xpm,'gpuArray')
    X =  cast(X,'like',Xpm);
end
