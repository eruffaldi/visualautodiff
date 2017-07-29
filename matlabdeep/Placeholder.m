classdef Placeholder < DeepOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
       type 
    end
    
    methods
         function obj = Placeholder(n,shape)
            obj = obj@DeepOp();
            obj.name = n;
            obj.type = 'float';
            obj.xvalue = [];
            obj.xshape = shape;
         end
         
         function set(obj,value)
             obj.xvalue = value;
         end
         
         function reset(obj)             
         end
        
         function r = eval(obj)
             assert(~isempty(obj.xvalue),'placeholder needs assignment');
             r = obj.xvalue;
         end
         
         function grad(obj,up)
             % no gradient for placeholder!
         end
         
         function gradshape(obj,up)
             % no gradient for placeholder!
         end
         
         function r = evalshape(obj)
             obj.xshape = size(obj.xvalue);
             r = obj.xshape;
         end
    end
    
end

