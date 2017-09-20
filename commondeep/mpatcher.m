% makes patches using sparse matrix
%
% X = input data unpatched
% Sel = sparse matrix Q x P
% sXp = output shape as provided by mpatchprepare
% 
% Output: Xp patches
function Xp = mpatcher(X,Sel,sXp)

nB = size(X,1);
%sXp(1) = sXp(1)*nB;  % removed
% sel: [ H W C, P F C]
% as:  [ N H W C ]
% Xp:  [ N P F C ]
as = reshape(X,nB,[]); % [nB , Ih Iw C]

%sparse Approach: only double and optimizable
%w = double(as)*Sel.A';
if isa(as,'gpuArray')
    w = gathermatrix(Sel.pickidx,gather(as),length(Sel.pickidx));
else
    if isstruct(Sel)
        f = Sel.gather;
        w = f(Sel.pickidx,as,length(Sel.pickidx));
    else
        % SIMULINK use manual gathermatrix
        w = gathermatrixmat(Sel,as,length(Sel));
    end
end
Xp = reshape(w,sXp); % [nB , P, F, C]
if isa(as,'gpuArray')    
    Xp =  cast(Xp,'like',as);
end
