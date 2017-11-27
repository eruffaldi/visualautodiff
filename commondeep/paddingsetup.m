function [paddingout, sizeout, offsetout] = paddingsetup(sizein,filtersize,stride,padding)
% TODO stride not supported
% TODO case of sizein < filtersize

offsetout= [0,0];

% -2 means that we put each point in the center
% -1 means that the output has the same size
if padding == -1
    if all(stride == 1)
        rems = filtersize-1;
        tops = floor(rems/2);
        bots = rems-tops;
        paddingout = [tops,bots];
        sizeout = sizein;
    else
        assert(all(stride == 2),'only');
        paddingout = [0,0,0,0];
        sizeout = sizein/2;
    end
elseif padding == -2
    % TODO use stride
    nextsize = floor((sizein+filtersize-1)./filtersize).*filtersize;
    rems = nextsize-sizein;
    tops = floor(rems/2);
    bots = rems-tops;
    paddingout = [tops,bots];
    sizeout = nextsize;
else
    % TODO verify if not valid
    paddingout = padding;
    sizeout = sizein;
end            
