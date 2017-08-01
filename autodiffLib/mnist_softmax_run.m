%%
tic;s=sim('mnist_softmax','SimulationMode','rapid');toc; s.realtout.Data(end)-s.realtout.Data(1)

%%
tic;s=sim('mnist_softmax','SimulationMode','accelerator');toc; s.realtout.Data(end)-s.realtout.Data(1)
%%

tic;s=sim('mnist_softmax','SimulationMode','normal');toc; s.realtout.Data(end)-s.realtout.Data(1)