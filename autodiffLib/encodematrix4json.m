function r= encodematrix4json(m,forceorder)

if nargin == 1
    forceorder = 'C';
end

r=[];
r.type = class(m);
r.shape = size(m);
if forceorder == 'C'
    r.order = 'C';
    mv = m;
else
    r.order = 'R';
    mv = permute(m,length(size(m)):-1:1);
end
r.data = typecast(mv(:), 'uint8');
