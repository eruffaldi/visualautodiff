classdef (Abstract) Optimizer < DeepOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        target
    end
      
    % add sum as AddOp
    
    methods        
        function grad(obj,up)
        end
        
        function gradshape(obj,ts)
        end
        function r = evalshape(obj)
            r = 1;
            obj.target.evalshape();
            obj.xshape = 1;
        end
   
    end
    
end

