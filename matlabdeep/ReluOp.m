classdef ReluOp < DeepOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        left
    end
    
    methods
        function obj = ReluOp(a)
            obj = obj@DeepOp();
            obj.left = a;
        end
        
        function r = eval(obj)
            r = obj.left.eval();
            obj.xvalue = max(r,0);
            r = obj.xvalue;
        end

        function r = evalshape(obj)
            r = obj.left.evalshape();
        end

        function grad(obj,up)
            % TODO
            obj.left.grad(up);
        end

        function gradshape(obj,up)
            obj.left.gradshape(up);
        end

    end
    
end

