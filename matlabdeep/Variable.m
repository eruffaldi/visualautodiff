classdef Variable < DeepOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        initvalue
    end
    
    methods
         function obj = Variable(initvalue)
            obj = obj@DeepOp();
            obj.initvalue = initvalue;
            if isa(initvalue,'function_handle')
                v = initvalue();
            else
                v = initvalue;
            end
            obj.xvalue = v;
            obj.xshape = size(v);
             obj.xgrad = mzeros(obj.xshape);
         end
         
         function r = evalshape(obj)
             r = obj.xshape;
         end

         function resetgrad(obj)             
             obj.xgrad = mzeros(obj.xshape);
         end

        function resetvalue(obj)             
            if isa(initvalue,'function_handle')
                v = initvalue();
            else
                v = initvalue;
            end
            obj.xvalue = v;
            obj.xshape = size(v);
             obj.xgrad = mzeros(obj.xshape);
         end

         function reset(obj)             
            % no reset
         end
        
         function r = eval(obj)
             r = obj.xvalue;
         end

         function increment(obj,v)
             obj.xvalue = obj.xvalue + v;
         end

         function grad(obj,up)
             obj.xgrad = obj.xgrad + up;
         end
         
         function gradshape(obj,up)
         end
         
         function g = getgrad(obj)
             g = obj.xgrad;
         end
         
    end
    
    
end

