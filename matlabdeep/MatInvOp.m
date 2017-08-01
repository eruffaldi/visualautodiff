classdef MatInvOp < ElementWiseUnaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function obj = MatInvOp(a)
            obj = obj@ElementWiseUnaryOp(a);
        end
        
        function r = eval(obj)
            x = obj.left.eval();
            obj.xvalue = inv(x);
            r = obj.xvalue;
        end

        function r = evalshape(obj)
            obj.xshape = obj.left.evalshape();
            r = obj.xshape;
        end

        function grad(obj,up)
            % - inv(X) U inv(X)
            obj.left.grad(-obj.xvalue*up*obj.xvalue);
        end

    end
    
end

