function p = stats_path(override)

persistent base

if nargin > 0
    base = override;
    return
end

if isempty(base)
    c = chdir;
    p = [c filesep '..' filesep 'statsdata'];
else
    p = base;
end
    
  if exist(p,'dir') == 0
  mkdir(p);
  end