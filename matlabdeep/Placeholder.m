classdef Placeholder < DeepOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
       xtype
    end
    
    methods
         function obj = Placeholder(n,shape)
            obj = obj@DeepOp();
            obj.name = n;
            obj.xtype = DeepOp.setgetDefaultType();
            obj.xvalue = [];
            obj.xshape = shape;
         end
         
         function shapechanged = set(obj,value)
             value = cast(value,'like',obj.xtype);
             nowshape = size(value);
             obj.xvalue = value;
             shapechanged = length(nowshape) ~= length(obj.xshape);
             if shapechanged == 0    
                 shapechanged = any(nowshape ~= obj.xshape);
             end
             obj.xshape = nowshape;
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

