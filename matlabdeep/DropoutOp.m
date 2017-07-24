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
        end
        
        function r = evalshape(obj)
        end
        
        function grad(obj,up)
        end
        
        function gradshape(obj,up)
        end
    end
    
end

