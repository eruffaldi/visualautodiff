function [r1,r2] = superconst(phase,inshape,intype,varargin)

disp('superconst')
phase
for I=1:length(inshape)
    disp(sprintf('inshape %d',I));
    inshape{I}
end
for I=1:length(intype)
    disp(sprintf('intype %d',I));
    intype{I}
end

for I=1:length(varargin)
    disp(sprintf('paramsin %d',I));
    varargin{I}
end

switch(phase)
    case 0 % size
        r1 =[2,2];
        r2 = [2,3,4];
    case 1 % type
        r1 = double(0);
        r2 = int32(0);
    case 2
        r1 = zeros(2);
        r2 = ones(2,3,4,'int32');
end
end