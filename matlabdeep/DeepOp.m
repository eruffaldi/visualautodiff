classdef (Abstract) DeepOp < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        xvalue
        xshape
        xgrad
        name
    end
    
    methods (Abstract)        
        eval(obj)
        evalshape(obj)
        grad(obj,up)
        gradshape(obj,up)
    end
   
    % add sum as AddOp
    
    methods
        function r = evalwith(obj,placeholders)
            obj.reset();
            for I=1:2:length(placeholders)
                placeholders{I}.set(placeholders{I+1});
            end
            obj.evalshape();
            r = obj.eval();
        end
        
        function reset(obj)
        end
        
        function visit(obj,fx)
            fx(obj);
        end
    end
    
end

