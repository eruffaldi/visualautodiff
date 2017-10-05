function saveMNISTImagesLE(filename,images,raw,info)
%loadMNISTImages returns a 28x28x[number of MNIST images] matrix containing
%the raw MNIST images

fp = fopen(filename, 'wb');
assert(fp ~= -1, ['Could not open ', filename, '']);

[numImages,numRows,numCols] = deal(info(1),info(2),info(3));
fwrite(fp, 2015,'int32');
fwrite(fp, numImages,'int32');
fwrite(fp, numRows,'int32');
fwrite(fp, numCols,'int32');
fwrite(fp, raw,'unsigned char');
fclose(fp);

end
