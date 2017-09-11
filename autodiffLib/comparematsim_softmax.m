
% Verification
lastepoch = find(sim_newepoch.Data(1,:,:),1,'last');
P = sim_predictions0.Data(:,:,lastepoch:end-1);
PP = reshape(cast(P,'single'),[],1);
L = sim_labels.Data(:,:,lastepoch:end-1);
LL = cast(L,'like',test_label);
X = sim_x.Data(:,:,lastepoch:end-1);

LL0 = reshape(LL,[],1);
IDX = sim_indices.Data(:,:,lastepoch:end-1);
UIDX = sort(unique(IDX));
size(UIDX)
size(IDX)
[UIDX(1),UIDX(end)]
missingU = setdiff(1:10000,UIDX)
[missing,IA] = setdiff(1:10000,reshape(IDX,1,[]));
samelabels = sum(test_label ==LL0)
sameprediction = sum(prediction==PP)
[min(PP),max(PP)]
[min(prediction),max(prediction)]
q1 = reshape(X(1,:,1),28,28);
m1 = reshape(test_images(1,:,:),28,28);
sum(q1(:)-m1(:))
