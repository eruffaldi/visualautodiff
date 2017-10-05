function saveMNISTLabelsLE(filename,labels)
%loadMNISTLabels returns a [number of MNIST images]x1 matrix containing
%the labels for the MNIST images

fp = fopen(filename, 'wb');
fwrite(fp, 2049, 'int32');
fwrite(fp, length(labels), 'int32');
fwrite(fp, labels, 'unsigned char');
fclose(fp);

end
