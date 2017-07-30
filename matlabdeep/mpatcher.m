function Xp = mpatcher(X,Sel,sXp)

nB = size(X,1);

sXp(1) = nB;
as = reshape(X,nB,size(Sel,2)); % [nB , Ih Iw C]
Xp = reshape(as*Sel',sXp); % [nB , Ph Pw]
