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
Xp = reshape(double(as)*Sel',sXp); % [nB , P, F, C]
