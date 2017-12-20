function [type,sizes] = decodeOpaqueTypeName(name)

a = strsplit(name,'_');

switch(a{1})
    case 'f'
        type = 'single';
    case 'd'
        type = 'double';
    otherwise
        type = 'uint32';
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
