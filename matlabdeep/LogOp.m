classdef LogOp < UnaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function obj = LogOp(a)
            obj = obj@UnaryOp(a);
        end
        
        function r = eval(obj)
            r = obj.left.eval();
            obj.xvalue = log(r);
            r = obj.xvalue;
        end

        function r = evalshape(obj)
            obj.xshape = obj.left.evalshape();
            r = obj.xshape;
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

