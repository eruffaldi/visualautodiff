function Xp = mpatcher(X,Sel,sXp)

nB = size(X,1);

sXp(1) = nB;
% sel: [ H W C, P F C]
% as:  [ N H W C ]
% Xp:  [ N P F C ]
as = reshape(X,nB,[]); % [nB , Ih Iw C]
Xp = reshape(as*Sel',sXp); % [nB , P, F, C]
