%%
o = stats_collect();

o = o(o.total_params < 100000,:); % & o.iterations == 6000,:);
o.simulation_mode = cellfun(@makecellstr,o.simulation_mode,'UniformOutput',false);

o = table_addfield(o,'singlecore',1);
% assert epochs
% assert type=single
% assert cnn_specs
%TODO add singlecore flag
og1 = grpstats(o,{'implementation','test','simulation_mode','gpu','singlecore'},@min,'DataVars',{'training_time','testing_time'});
%,'cm_accuracy','cm_Fscore','cm_F1'});
og2 = grpstats(o,{'implementation','test','simulation_mode','gpu','singlecore'},@max,'DataVars',{'accuracy','cm_accuracy','cm_Fscore'});
og = og1;
z ={'max_accuracy','max_cm_accuracy','max_cm_Fscore'};
for J=1:length(z)
    og.(z{J}) = og2.(z{J});
end
%,''
%''
%'simulation_mode'
%%
% Performance Table


%%
% Speed 
