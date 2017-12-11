classdef ConstantOp < DeepOp
    
    properties
    end
    
    methods
        function r = eval(obj)
            r = obj.xvalue;
        end

        function r = evalshape(obj)
            obj.xshape = size(obj.xvalue);
            r = obj.xshape;
        end
        

        function reset(obj)
        end
        
        function up = grad(obj,up)
        end


    end
    
    
end

