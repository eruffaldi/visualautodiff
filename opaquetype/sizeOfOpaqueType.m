function s = sizeOfOpaqueType(typename,i)

    [type,sizes] = decodeOpaqueTypeName(typename);
    if nargin == 1
        s = sizes;
    else
        if i >length(sizes)
            s = 1;
        else
            s = sizes(i);
        end
    end
