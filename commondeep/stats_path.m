function p = stats_path

c = chdir;
p = [c filesep '..' filesep 'statsdata'];
  if exist(p,'dir') == 0
  mkdir(p);
  end