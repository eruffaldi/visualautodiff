function o = stats_collect(fields)

o = [];
pa = stats_path();
d = dir(pa);
for I=1:length(d)
    if d(I).isdir == 0 & d(I).name(1) ~= '.'
        fp = [d(I).folder,filesep,d(I).name];
        if endsWith(d(I).name,'.json')
            w = jsondecode(fileread(fp));
        elseif endsWith(d(I).name,'.mat')
            w = load(fp);
           w = w.data;
        else
            continue
        end
        if isstruct(w)
            if isempty(o)
                o = struct2table(w);
            else
                ff = fieldnames(w);
                first = 1;
                for I=1:length(ff)
                    fi = strcmp(o.Properties.VariableNames,ff{I});
                    v = w.(ff{I});
                    if sum(fi) == 0 % not existent
                        if iscell(v)
                            o.(ff{I}) = cell(height(o),size(v));
                        elseif ischar(v)
                            v = {v};
                            o.(ff{I}) = cell(height(o),1);
                        else
                            ss = size(v);
                            ss(1) = height(o);
                            o.(ff{I}) = zeros(ss,'like',v);
                        end
                    else
                        if ischar(v) 
                            v = {v};
                            if iscell(o.(ff{I})) == 0
                                o.(ff{I}) = cellstr(o.(ff{I}));
                            end
                        end
                    end                
                    if ndims(v) > 2 || numel(v) > 1
                        o.(ff{I})(end+first,:) = v;                            
                    else                            
                        o.(ff{I})(end+first) = v;
                    end
                    first = 0;
                end
            end
        elseif isa(w,'table')
            if isempty(o)
                o = w;
            else
                o = [o; w];
            end
        end
    end
end
