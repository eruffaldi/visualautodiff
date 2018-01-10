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
%og2 = grpstats(o,{'implementation','test','simulation_mode','gpu','singlecore'},@max,'DataVars',{'accuracy','cm_accuracy','cm_Fscore'});
%og = og1;
%z ={'max_accuracy','max_cm_accuracy','max_cm_Fscore'};
%for J=1:length(z)
%    og.(z{J}) = og2.(z{J});
%end

%{'implementation','test','simulation_mode','gpu','singlecore'}
og = grpstats(o,{'id','test'},{@mean,@std},'DataVars',{'training_time','testing_time'});

%%
% one line for every id
out = {};
tests = {'softmax','cnn'};
lightout =0;
if lightout
    names = {'','','','','','','','',''};
    annotatebold= @(x) x;
    annotatesmall = @(x) sprintf('%3f',x);
else
    names = {'Tensorflow GPU','Matlab GPU','Tensorflow CPU ST', 'Tensorflow CPU MT','Matlab CPU MT','Simulink Interpreted CPU S','Simulink Codegen CPU ST','Simulink Codegen BLAS CPU ST','Simulink Codegen BLAS CPU MT'};
    annotatebold = @(x) sprintf('\textbf{%s}',x);
    annotatesmall = @(x) sprintf('{\scriptstyle %3f}',x);
end
for I=1:9
    cid = sprintf('C%d',I);
    out{I,1} = annotatebold(cid);
    out{I,2} = annotatebold(names{I});
    for J=1:length(tests)
        oI = og(strcmp(og.id,cid) & strcmp(og.test,tests{J}),:);
        out{I,2+J*2} = sprintf('%3.1f +- %s',oI.mean_training_time,annotatesmall(oI.std_training_time));
        out{I,2+J*2+1} = sprintf('%3.1f +- %s',oI.mean_testing_time,annotatesmall(oI.std_testing_time));
    end
end
out{end} = [out{end}+  '\\ \hline'];

%%




%%
% Speed 
