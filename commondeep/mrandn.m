%
% (m)eaningful randn
%
% Y = mrandn(shape,[template])
%
% Creates a randn object using shape and provided type template. This form
% of allows to:
% - pass scalar shape to express row vectors and not just square matrices
% - copy the type of the template e.g. gpuArray of single
%
% Example
% Y = mrandn(5,gpuArray(single(0))); 
%    a [1,5] vector on gpu as single
% Y = mrandn([3,2],int32(0));
%    a [3,2] matrix as int32
%
% See mzeros, mones
%
% Emanuele Ruffaldi 2017 @ SSSA
function r = mrandn(a,t)

if length(a) == 1
    a = [1,a];
end
if nargin == 1
    r = randn(a);
else
    if ischar(t)    
        r = randn(a,t);
    else
        if isa(t,'gpuArray')
            r = randn(a,classUnderlying(t),'gpuArray');
        else
            r = randn(a,class(t));
        end
    end
end
    
    