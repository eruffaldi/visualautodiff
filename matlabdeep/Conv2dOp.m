classdef Conv2dOp < BinaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        stride
    end
    
    methods
        % [batch, in_height, in_width, in_channels]
        % [filter_height, filter_width, in_channels, out_channels]
        function obj = Conv2dOp(x,W,stride,pad)
            assert(all(stride==1),'only stride 1');
            assert(strcmp(pad,'SAME'),'only pad SAME');
            assert(isa(W,'Variable'),'W should be variable');
            assert(length(W.xshape) == 4,'W should have 4D shape: K K 1 F');
            obj = obj@BinaryOp(x,W);
            obj.stride = stride;
        end
        
        function r = eval(obj)
            obj.left.eval();
            obj.right.eval();
            obj.xvalue = mzeros(obj.xshape);
            r = obj.xvalue;
        end
        
        function r = evalshape(obj)
            xl = obj.left.evalshape();
            xr = obj.right.evalshape();
            assert(length(xl) == 4);
            assert(length(xr) == 4);
            assert(xl(4) == xr(3),'in_channel same');
            
            % assuming stride 1 
            obj.xshape = [xl(1) xl(2) xl(3) xr(4)]; 
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

