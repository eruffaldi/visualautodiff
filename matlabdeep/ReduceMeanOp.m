classdef ReduceMeanOp < DeepOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        left
    end
    
    methods
        function obj = ReduceMeanOp(x)
            obj = obj@DeepOp();
            obj.left = x;
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

