classdef Placeholder < DeepOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
       type 
    end
    
    methods
         function obj = Placeholder(t,shape)
            obj = obj@DeepOp();
            obj.type = t;
            obj.xvalue = [];
            obj.xshape = shape;
         end
         
         function set(obj,value)
             obj.xvalue = value;
         end
         
         function reset(obj)             
             obj.xgrad = zeros(obj.xshape);
         end
        
         function r = eval(obj)
             assert(~isempty(obj.xvalue),'placeholder needs assignment');
             r = obj.xvalue;
         end
         
         function grad(obj,up)
             obj.xgrad = obj.xgrad + up;
         end
         
         function gradshape(obj,up)
         end
         
         function r = evalshape(obj)
             obj.xshape = size(obj.xvalue);
             r = obj.xshape;
         end
    end
    
end

