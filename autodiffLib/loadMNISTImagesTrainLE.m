function images = loadMNISTIImagesLE(filename)
%loadMNISTImages returns a 28x28x[number of MNIST images] matrix containing
%the raw MNIST images

fp = fopen(filename, 'rb');
%assert(fp ~= -1, ['Could not open ', filename, '']);

magic = fread(fp, 1, 'int32', 0);
%assert(magic == 2015, ['Bad magic number in ', filename, '']);

numImages = fread(fp, 1, 'int32', 0);
numRows = fread(fp, 1, 'int32', 0);
numCols = fread(fp, 1, 'int32', 0);
numRows = 28;
numCols = 28;
numImages = 60000;

images = fread(fp, 60000*28*28, 'unsigned char');
images = reshape(images, numCols, numRows, numImages);
images = permute(images,[2 1 3]);

fclose(fp);

% Reshape to #pixels x #examples
images = reshape(images, size(images, 1) * size(images, 2), size(images, 3));
% Convert to double and rescale to [0,1]
images = double(images) / 255;

end
