function n = encodeOpaqueTypeName(type,sizes)

t='u';
if ischar(type)
    if strcmp(type,'single')
        t = 'f';
    elseif strcmp(type,'double')
        t = 'd';
    else
        t = 'u';
    end
else
if isa(type,'single')
    t='f';
elseif isa(type,'double')
    t='d';
end
end
n = sprintf('%s_%d_%s',t,length(sizes),strjoin(arrayfun(@int2str,sizes,'UniformOutput',false),'_'));