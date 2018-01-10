classdef ArgmaxOp < UnaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        axis
    end
    
    methods
        function obj = ArgmaxOp(a,axis)
            obj = obj@UnaryOp(a);
            obj.axis = axis;
        end
        
        function r = eval(obj)
            x = obj.left.eval();
            [~,obj.xvalue] = max(x,[],obj.axis);
            obj.xvalue = cast(obj.xvalue,'like',x);
            r = obj.xvalue;
        end

        function r = evalshape(obj)
            s = obj.left.evalshape();
            s(obj.axis) = [];
            obj.xshape = s;
            r = obj.xshape;
        end

        function grad(obj,up)
            error('ArgmaxOp has no gradient');
        end

        function gradshape(obj,up)
            obj.left.gradshape(up);
        end

    end
    
end

