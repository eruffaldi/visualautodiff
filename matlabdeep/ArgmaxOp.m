classdef ArgmaxOp < DeepOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        left
        axis
    end
    
    methods
        function obj = ArgmaxOp(a,axis)
            obj = obj@DeepOp();
            obj.left = a;
            obj.axis = axis;
        end
        
        function r = eval(obj)
            r = obj.left.eval();
            obj.xvalue = 0;
            r = obj.xvalue;
        end

        function r = evalshape(obj)
            r = obj.left.evalshape();
        end

        function grad(obj,up)
            % TODO
        end

        function gradshape(obj,up)
            % TODO
            obj.left.evalshape(up);
        end

    end
    
end

