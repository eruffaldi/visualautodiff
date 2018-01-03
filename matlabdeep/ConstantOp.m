classdef ConstantOp < DeepOp
    
    properties
    end
    
    methods
        function obj = ConstantOp(x)
            obj.xvalue = x;
        end
        
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

        function r = gradshape(obj,ts)
        end

    end
    
    
end

