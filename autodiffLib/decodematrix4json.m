function m = decodematrix4json(s)

assert(isstruct(s));
s
type = s.type;
switch(type)
    case 'float32','float'
        type = 'single'
    case 'float64'
        type = 'double'
end
order = s.order;
assert(order == 'C' || order == 'R');
shape = s.shape;

if ischar(s.data)
    dd = cast(s.data,'uint8'); % char to uint8
else
    dd = cast(s.data,'uint8'); % double to uint8
end
mv = typecast(dd,type);
if length(shape) == 1
    shape = [shape,1]; % numpy is ...
end
if order == 'C'
    m = reshape(mv,shape);
else
    m = reshape(mv,shape(end:-1:1));
    m = permute(m,length(shape):-1:1);
end
