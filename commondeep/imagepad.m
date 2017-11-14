% [k,i,j] = imagepad(1,[28,28],5,5,0,[2,2])

% padding is 4d: top left bottom right
% stride is  2d
% k is NOT neeed
function [outshape,outshapegroup,iH,iW,iC] = imagepad(inputform,outputform,inputshape,field_height,field_width,padding,stride,colmajor)

H = inputshape(inputform.W);
W = inputshape(inputform.H);
stridey = stride(1);
stridex = stride(2);

assert (mod(H + padding(1)+padding(3) - field_height,stridey) == 0,'alignment of pad and stride-size in H');
assert (mod(W + padding(2)+padding(4) - field_width,  stridex) == 0,'alignment of pad and stride-size in W');
out_height = (H + padding(1)+padding(3)-field_height ) / stridey+1 ;
out_width = (W + padding(2)+padding(4)-field_width ) / stridex+1;
outshape = [out_height out_width];

% np.repeat(np.arange(A), B) =>  as 0000 1111 2222 ..
% np.tile(np.arange(A), B))  =>  as 012 012 012e
blockrepeat0= @(A,B) reshape(repmat((1:A)-1,B,1),1,[]); % iterate 0..(A-1) repeating B times each: (0){B}...(A-1){B}
interrepeat0= @(A,B) reshape(repmat((1:A)-1,1,B),1,[]); % iterate 0..(A-1) blockwise repeat:  ((0)..(A-1)){B}
blockrepeat= @(S,B) reshape(repmat(S,B,1),1,[]); % iterate 0..(A-1) repeating B times each: (0){B}...(A-1){B}
interrepeat= @(S,B) reshape(repmat(S,1,B),1,[]); % iterate 0..(A-1) blockwise repeat:  ((0)..(A-1)){B}

if colmajor == 0
    loopnew0 = blockrepeat0;
    loopnew = blockrepeat;
    loopold0 = interrepeat0;
    loopold = interrepeat;
else
    loopold0 = blockrepeat0;
    loopold = blockrepeat;
    loopnew0 = interrepeat0;
    loopnew = interrepeat;
    
end

inputform = orderstructbyvalues(inputform);
outputform = orderstructbyvalues(outputform);

iH = [];
iW = [];
iC = [];
S = 1; % current size
fo = fieldnames(outputform);
outshape = [];
outshapegroup = struct('C',1,'W',1,'H',1);

for I=1:length(fo)
    f = fo{I};
    
    switch(f)
    case 'B' % batch (ignored, should be first or last)
        N = inputshape(inputform.(f));
        assert(I == 1 || I == length(fo),'batch should be first or last');
        continue
    case 'C' % feature of input
        N = inputshape(inputform.(f));
        assert(isempty(iC),'no repetitions for C');
                    focus = 'C';
        zi = 0:N-1;
    case 'w' % kernel width
        N = field_width;
        focus ='W';
        if 0==1
            if mod(N,2) == 0
                zi = -N/2:(N/2-1);
            else
                zi = -(N-1)/2:(N-1)/2;
            end
        else
            zi = 0:(N-1);
        end
    case 'h' % kernel height
        N = field_height;
        focus ='H';
        % compose with existing
        if 0==1
            if mod(N,2)
                zi = -N/2:(N/2-1);
            else
                zi = -(N-1)/2:(N-1)/2;
            end
        else
            zi = 0:(N-1);
        end
    case 'W' % image width
        N = inputshape(inputform.(f));
        % compose with existing
        focus ='W';
        zi = 0:stridex:(N-1);
    case 'H' % image height
        N = inputshape(inputform.(f));
        focus ='H';
        zi = 0:stridey:(N-1);
    otherwise
        error(sprintf('unknown field %d',f));
    end
    outshape.(f) = length(zi);
    N = length(zi);
    if focus == 'C'
        outshapegroup.C = outshapegroup.C * N;
    elseif focus == 'H'
        outshapegroup.H = outshapegroup.H * N;
    elseif focus == 'W'
        outshapegroup.W = outshapegroup.W * N;
    end
    if nargin <2
    else
        if focus ~= 'C'
            iC = loopold(iC,N);
        else
            % compose with existing
            if isempty(iC)
                iC = loopnew(zi,S);
            else
                % nested loop compositing with the previous
                zia = loopnew(zi,S);
                pre = loopold(iC,N);
                iC = pre + zia;
            end        
        end
        if focus ~= 'W'
            iW = loopold(iW,N);
        else
            % compose with existing
            if isempty(iW)
                iW = loopnew(zi,S);
            else
                % nested loop compositing with the previous
                zia = loopnew(zi,S);
                pre = loopold(iW,N);
                iW = pre + zia;
            end                
        end
        if focus ~= 'H'
            iH = loopold(iH,N);
        else
            % compose with existing
            if isempty(iH)
                iH = loopnew(zi,S);
            else
                % nested loop compositing with the previous
                zia = loopnew(zi,S);
                pre = loopold(iH,N);
                iH = pre + zia;
            end        
        end
    end
    S = S * N;
    
end
if isempty(iH)
iH = zeros(1,S);
end
if isempty(iW)
iW = zeros(1,S);
end
if isempty(iC)
iC = zeros(1,S);
end

end
