function X = munpatcher(Xp,Sel,NHWCshape)

nB = NHWCshape(1);
Ih = NHWCshape(2);
Iw = NHWCshape(3);
nC = NHWCshape(4);

Xpm = reshape(Xp,nB,[]); % keep on the left
X = reshape(Xpm*Sel,nB,Ih,Iw,nC); % product is Nx(Ih Iw C)
