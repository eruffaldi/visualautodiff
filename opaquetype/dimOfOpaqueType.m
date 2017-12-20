function s = dimOfOpaqueType(typename)

    [type,sizes] = decodeOpaqueTypeName(typename);
    s = length(sizes);
    
