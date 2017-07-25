classdef DropoutOp < DeepOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        left
        prob
    end
    
    methods
        function obj = DropoutOp(left,prob)
            obj = obj@DeepOp();
            obj.left = left;
            obj.prob = prob;
        end
        
        function r = eval(obj)
            % TODO droppping
            obj.xvalue = obj.left.eval();
            r = obj.xvalue;
        end
        
        function r = evalshape(obj)
            obj.xshape = obj.left.evalshape();
            r = obj.xshape;
        end
        
        function grad(obj,up)
            % TODO masking
            obj.left.grad(up);
        end
        
        function gradshape(obj,up)
            obj.left.gradshape(up);
        end
    end
    
end

