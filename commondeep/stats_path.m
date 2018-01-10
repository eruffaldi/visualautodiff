function p = stats_path(override,rec)

persistent base

if nargin > 0
	if nargin < 2
		rec = 0;
	end
	if iscell(override)== 0 & rec == 1
		q = dir([override '/*']);
		out ={};
		for J=1:length(q)
			if q(J).isdir
				if q(J).name(1) ~= '.'
					out{end+1} = [override, '/', q(J).name];
				end
			end
		end

		override = out; 
	end
    base = override;
    return
end

if isempty(base)
    c = chdir;
    p = [c filesep '..' filesep 'statsdata'];
else
    p = base;
end
    
    if iscell(p) == 0
  		if exist(p,'dir') == 0
  			mkdir(p);
  		end
  		p = {p};
  end