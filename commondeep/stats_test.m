stats_clean

%%
stats_add(struct('ciao',123,'mondo','wow'));
stats_add(struct('ciao',123,'mondo','wow!','next',10000));
stats_add(struct('ciao',123,'mondo','wow!','next',10000,'files',[1,2,3]));
stats_add(struct('ciao',123,'mondo','wow!','next',10000,'files',[1,2,3]));

%%
z = stats_collect();