function s = sizeOfOpaqueType(typename)


    [type,sizes] = decodeOpaqueTypeName(type);
r= 1;
if isa(type,'single')
    r = 4;
elseif isa(type,'double')
    r = 8;
else
    r = 4;
end
s = r * prod(sizes);
