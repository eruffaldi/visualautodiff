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

        function r = evalshapewith(obj,placeholders)
            obj.reset();
            sa = 0;
            for I=1:2:length(placeholders)
               sa = sa | placeholders{I}.set(placeholders{I+1});
            end
            if sa ~= 0
                obj.evalshape();
            end
        end

        function reset(obj)
        end
        
        function visit(obj,fx)
            fx(obj);
        end
    end
    
end

