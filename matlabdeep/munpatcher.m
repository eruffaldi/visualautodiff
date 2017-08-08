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
function X = munpatcher(Xp,Sel,NHWCshape)

nB = NHWCshape(1);
Ih = NHWCshape(2);
Iw = NHWCshape(3);
nC = NHWCshape(4);

Xpm = reshape(Xp,nB,[]); % keep on the left
X = reshape(Xpm*Sel,nB,Ih,Iw,nC); % product is Nx(Ih Iw C)
