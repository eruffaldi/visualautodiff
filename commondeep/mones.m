%
% (m)eaningful ones
%
% Y = ones(shape,[template])
%
% Creates a ones object using shape and provided type template. This form
% of allows to:
% - pass scalar shape to express row vectors and not just square matrices
% - copy the type of the template e.g. gpuArray of single
%
% Example
% Y = mones(5,gpuArray(single(0))); 
%    a [1,5] vector on gpu as single
% Y = mones([3,2],int32(0));
%    a [3,2] matrix as int32
%
% See mzeros, mrandn
%
% Emanuele Ruffaldi 2017 @ SSSA
function r = mones(a,t)

if length(a) == 1
    a = [1,a];
end
if nargin == 1
    r = ones(a);
else
    if ischar(t)    
        r = ones(a,t);
    else
        r = ones(a,'like',t);
    end
end
    