classdef ReduceMeanOp < UnaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        % only full reduction
        function obj = ReduceMeanOp(x)
            
            obj = obj@UnaryOp(x);
        end
        
        function r = eval(obj)
            x = obj.left.eval();
            r = mean(x(:));
        end
        
        function r = evalshape(obj)
            obj.left.evalshape();
            r = 1;
        end
        
        function grad(obj,up)
            warning('ReduceMeanOp TODO implement gradient');
            obj.left.grad(up);
        end
        
        function gradshape(obj,up)
        end
    end
    
end

