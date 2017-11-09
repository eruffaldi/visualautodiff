function [images,raw,info] = loadMNISTImages(filename,colmajor)
%loadMNISTImages returns a 28x28x[number of MNIST images] matrix containing
%the raw MNIST images
if nargin == 1
    colmajor = 0;
end
fp = fopen(filename, 'rb');
assert(fp ~= -1, ['Could not open ', filename, '']);

magic = fread(fp, 1, 'int32', 0, 'ieee-be');
assert(magic == 2051, ['Bad magic number in ', filename, '']);

numImages = fread(fp, 1, 'int32', 0, 'ieee-be');
numRows = fread(fp, 1, 'int32', 0, 'ieee-be');
numCols = fread(fp, 1, 'int32', 0, 'ieee-be');

assert(numRows == 28);
assert(numCols == 28);

images = fread(fp, inf, 'unsigned char');
fclose(fp);

if colmajor == 1
    info = [numCols,numRows,numImages];
    images = reshape(images, numCols, numRows, numImages); % native form
    raw = images; % just a bit of reshaping for matlab niceness
    % Reshape to #pixels x #examples
    images = reshape(images, size(images, 1)*size(images,2), size(images, 3));
else
    info = [numImages,numRows,numCols];
    images = reshape(images, numCols, numRows, numImages);
    images = permute(images,[3 2 1]);
    raw = images; % just a bit of reshaping for matlab niceness
    % Reshape to #pixels x #examples
    images = reshape(images, size(images, 1),size(images, 2) * size(images, 3));
end



% Convert to double and rescale to [0,1]
images = double(images) / 255;

end
