function saveMNISTImagesLE(filename,raw,info,transposed)
%loadMNISTImages returns a 28x28x[number of MNIST images] matrix containing
%the raw MNIST images

fp = fopen(filename, 'wb');
assert(fp ~= -1, ['Could not open ', filename, '']);

[numImages,numRows,numCols] = deal(info(1),info(2),info(3));
assert(numImages == size(raw,1));
fwrite(fp, 2015,'int32');
if transposed
    raw = permute(raw,[2,3,1]);
    fwrite(fp, numRows,'int32');
    fwrite(fp, numCols,'int32');
    fwrite(fp, numImages,'int32');
    fwrite(fp, raw,'unsigned char');
else
    fwrite(fp, numImages,'int32');
    fwrite(fp, numRows,'int32');
    fwrite(fp, numCols,'int32');
    fwrite(fp, raw,'unsigned char');
end
fclose(fp);

end
