function stats_add(data,extra)

data.now_unix = 864e5 * (now - datenum('1970', 'yyyy'));
%data.machine = computer('arch');
data.machine = lower(computer); % plus other sig
pa = stats_path();
q= randi(10000,1);
out = datestr(now,'yyyymmddTHHMMSS.FFF');
pf = [pa,filesep,out,sprintf('-%d',q),'.mat'];

save(pf,'data');

if nargin > 1
    ff = fieldnames(extra);
    for I=1:length(ff)
        pq = [pa filesep ff{I}];
        mkdir(pq);
        pf = [pq,filesep,out,sprintf('-%d',q),'.mat'];
        s1 = [];
        s1.(ff{I}) = extra.(ff{I});
        save(pf,'-struct','s1');
    end
end
