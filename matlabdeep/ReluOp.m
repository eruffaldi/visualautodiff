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
            r = obj.evalshape();
        end

        function grad(obj,up)
            % TODO
        end

        function gradshape(obj,up)
            obj.left.evalshape(up);
        end

    end
    
end

