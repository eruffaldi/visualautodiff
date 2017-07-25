classdef (Abstract) DeepOp < handle
    
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

