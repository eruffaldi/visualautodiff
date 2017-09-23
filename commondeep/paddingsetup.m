function [paddingout, sizeout, offsetout] = paddingsetup(sizein,filtersize,stride,padding)

% TODO stride not supported

h_filter = filtersize(1);
w_filter = filtersize(2);

offsetout= [0,0];
sizeout = sizein;
rems = [rem(sizein(1),h_filter),rem(sizein(2),w_filter)];

if padding == -1
    tops = floor(rems/2);
    bots = rems-tops;
    paddingout = [tops,bots];
else
    % TODO verify if not valid
    paddingout = padding;
end            
