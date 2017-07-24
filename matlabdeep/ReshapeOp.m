classdef ReshapeOp < DeepOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        left
        
    end
    
    methods
        function obj = ReshapeOp(a,s)
            obj = obj@DeepOp();
            obj.left = a;
            obj.xshape = s;
        end
            
        function r = evalshape(obj)
            r = obj.xshape;
        end
        
        function r = eval(obj)            
            obj.value = reshape(obj.left.eval(),obj.xshape);
            r = obj.value;
        end
        
        function r = grad(obj,up)
            % [ outputs, inputs ]
            r = obj.left.grad(up);
        end
    end
end
    
end

