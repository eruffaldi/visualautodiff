classdef ReshapeOp < DeepOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        left
        eshape
    end
    
    methods
        function obj = ReshapeOp(a,s)
            obj = obj@DeepOp();
            obj.left = a;
            obj.eshape = s;
        end
            
        function r = evalshape(obj)
            xs = obj.left.evalshape();
            if obj.eshape(1) == -1
                obj.xshape = [xs(1) obj.eshape(2:end)];
            else
                obj.xshape = obj.eshape;
            end
            r = obj.xshape;
        end
        
        function r = eval(obj)            
            obj.xvalue = reshape(obj.left.eval(),obj.xshape);
            r = obj.xvalue;
        end
        
        function grad(obj,up)
            warning('ReshapeOp implement grad');
            obj.left.grad(up);
        end
        
        function gradshape(obj,up)
            warning('ReshapeOp implement gradshape');
            obj.left.gradshape(up); 
        end
    end
    
end

