classdef ReshapeOp < UnaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        eshape
    end
    
    methods
        function obj = ReshapeOp(a,s)
            obj = obj@UnaryOp(a);
            obj.eshape = s;
        end
            
        function r = evalshape(obj)
            xs = obj.left.evalshape();
            if obj.eshape(1) == -1
                obj.xshape = [xs(1) obj.eshape(2:end)];
            else
                obj.xshape = obj.eshape;
            end
            % make it row
            if length(obj.xshape) == 1
                obj.xshape = [obj.xshape,1];
            end
            r = obj.xshape;
        end
        
        function r = eval(obj)  
            xl = obj.left.eval();
            size(xl)
            obj.xshape
            obj.xvalue = reshape(xl,obj.xshape);
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

