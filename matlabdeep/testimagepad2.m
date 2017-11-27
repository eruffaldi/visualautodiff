% Generalized Form
inputform =string2struct('CWHB');
inputshape = [2,8,4,1]; % ordered as above
outputform = string2struct('whCWHB');
%outputform = string2struct('WHB');
Xi = mallindex(inputshape);
h_filter = 2;
w_filter = 2;
stride = [1,1,1,1];
paddinginput = -1;
colmajor = 1;

[padding,sizeout,offsetout] = paddingsetup([inputshape(inputform.H) inputshape(inputform.W)],[h_filter,w_filter],stride(2:3),paddinginput);
 
[outshape,outshapegroup,iH,iW,iC] = imagepad(inputform,outputform,inputshape,h_filter,w_filter,padding,stride,colmajor);
vals = [];
vals.C = iC;
vals.H = iH;
vals.W = iW;
vals.B = zeros(1,length(vals.C));
ovals = cellfun(@(x) vals.(x),fieldnames(inputform),'UniformOutput',false);
n = false(size(ovals{1}));
for I=1:length(ovals)
    n = n | (ovals{I} < 0) | ovals{I} > size(Xi,I);
end

% pick only good
for I=1:length(ovals)
    q = ovals{I};
    ovals{I} =q(n == 0);
end

w = sub2ind(size(Xi),ovals{1}+1,ovals{2}+1,ovals{3}+1,ovals{4}+1);

w2 = reshape(Xi(w),[inputshape(inputform.W) inputshape(inputform.H)]);
w2
