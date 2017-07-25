classdef MaxPoolOp < UnaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ksize
        strides
        pad
    end
    
    methods
        function obj = MaxPoolOp(x,ksize,strides,pad)
            assert(all(ksize == [1,2,2,1]),'only size [1,2,2,1]');
            assert(all(strides == [1,2,2,1]),'only size [1,2,2,1]');
            assert(strcmp(pad,'SAME'),'only pad SAME');
            obj = obj@UnaryOp(x);
            obj.ksize = ksize;
            obj.strides = strides;
            obj.pad = pad;
        end
        
        % [batch fw fh channels]
        function r = eval(obj)
            obj.left.eval();
            obj.xvalue = mzeros(obj.xshape);
            r = obj.xvalue;
        end
        
        function r = evalshape(obj)
            xl = obj.left.evalshape();
% special case
            obj.xshape = xl./obj.strides; %./obj.ksize;
            r = obj.xshape;
        end
        
        function grad(obj,up)
            obj.left.grad(up);
        end
        
        function gradshape(obj,up)
            obj.left.gradshape(up);
        end
    end
    
end

