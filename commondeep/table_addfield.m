function o =table_addfield(o,name,def);

Exist_Column = strcmp(name,o.Properties.VariableNames);
if sum(Exist_Column)==0
    o.(name) = repmat(def,height(o),1);
end

