classdef (Abstract) DeepOp < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        xvalue
        xshape
        xgrad
    end
    
    methods (Abstract)
        eval(obj)
        evalshape(obj)
        grad(obj,up)
        gradshape(obj,up)
    end
    
    methods
        function reset(obj)
        end
    end
    
end

