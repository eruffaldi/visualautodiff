function [type,sizes,mt] = decodeOpaqueTypeName(name)

a = strsplit(name,'_');

switch(a{1})
    case 'f'
        type = 'single';
        mt = single(0);
    case 'd'
        type = 'double';
        mt = double(0);
    otherwise
        type = 'uint32';
        mt = uint32(0);
end
if length(a) == 1
    sizes = [];
else
    if strcmp(a{end},'bus')
        a = a(1:end-1);
    end
    sizes = zeros(1,str2double(a{2}));
    for i=1:size(sizes,2)
        sizes(i) = str2double(a{2+i});
    end
end
