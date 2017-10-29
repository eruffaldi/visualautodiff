function stats_add(data)

data.now_unix = 864e5 * (now - datenum('1970', 'yyyy'));
%data.machine = computer('arch');
data.machine = lower(computer); % plus other sig
pa = stats_path();
q= randi(10000,1);
out = datestr(now,'yyyymmddTHHMMSS.FFF');
pa = [pa,filesep,out,sprintf('-%d',q),'.mat'];

save(pa,'data');