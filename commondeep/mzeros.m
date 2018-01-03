%
% (m)eaningful ones
%
% Y = mzeros(shape,[template])
%
% Creates a zeros object using shape and provided type template. This form
% of allows to:
% - pass scalar shape to express row vectors and not just square matrices
% - copy the type of the template e.g. gpuArray of single
%
% Example
% Y = mzeros(5,gpuArray(single(0))); 
%    a [1,5] vector on gpu as single
% Y = mzeros([3,2],int32(0));
%    a [3,2] matrix as int32
%
% See mones, mrandn
%
% Emanuele Ruffaldi 2017 @ SSSA
function r = mzeros(a,t)

if length(a) == 1
    a = [1,a];
end
if nargin == 1
    r = zeros(a);
else
    if ischar(t)    
        r = zeros(a,t);
    else
        r = zeros(a,class(t));
    end
end 
    