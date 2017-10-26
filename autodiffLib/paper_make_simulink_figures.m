%open_system('mnist_softmax_figure');
%%
print('mnist_softmax_figureX.pdf','-smnist_softmax_figure','-dpdf')
system('/Library/TeX/texbin/pdfcrop mnist_softmax_figureX.pdf mnist_softmax_figure.pdf')

%%
print('mnist_cnn_adam_figure.pdf','-smnist_cnn_adam_figure','-dpdf')
