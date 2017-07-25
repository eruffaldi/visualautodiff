classdef (Abstract) Optimizer < DeepOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
      
    % add sum as AddOp
    
    methods        
        function grad(obj,up)
        end
        
        function gradshape(obj,up)
        end
        function r = evalshape(obj)
            r = 1
        end
   
    end
    
end

