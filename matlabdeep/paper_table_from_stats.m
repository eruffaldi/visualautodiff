%%
o = stats_collect();

o = o(o.totalparams < 100000 & o.iterations == 6000,:);
o.simulation_mode = cellfun(@makecellstr,o.simulation_mode,'UniformOutput',false);
% assert epochs
% assert type=single
% assert cnn_specs
og = grpstats(o,{'implementation','test','simulation_mode','gpu','singlecore'},@mean,'DataVars',{'training_time','testing_time','cm_accuracy','cm_Fscore','cm_F1'});
%,''
%''
%'simulation_mode'
%%
% Performance Table


%%
% Speed 
