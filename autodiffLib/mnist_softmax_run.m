%%
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget('mnist_softmax')
%%
system('./mnist_softmax');
rt_realtout.signals.values(end)-rt_realtout.signals.values(2)
%%
tic;s=sim('mnist_softmax','SimulationMode','rapid');toc; s.realtout.signals.values(end)-s.realtout.signals.values(1)

%%
tic;s=sim('mnist_softmax','SimulationMode','accelerator');toc; s.realtout.signals.values(end)-s.realtout.signals.values(2)
%%

tic;s=sim('mnist_softmax','SimulationMode','normal');toc; s.realtout.signals.values(end)-s.realtout.signals.values(2)