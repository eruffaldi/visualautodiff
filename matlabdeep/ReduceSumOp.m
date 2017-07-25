classdef ReduceSumOp < UnaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        % only full reduction
        function obj = ReduceSumOp(x)            
            obj = obj@UnaryOp(x);
        end
        
        function r = eval(obj)
            x = obj.left.eval();
            r = sum(x(:));
        end
        
        function r = evalshape(obj)
            obj.left.evalshape();
            obj.xshape = 1;
            r = 1;
        end
        
        function grad(obj,up)
            assert(numel(up)  == 1);
            % f = sum x(ijkl) / N
            % df/dx = 1/N
            obj.left.grad(up);
        end        
    end
    
end

