classdef Variable < DeepOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        initvalue
        xid
    end
    
     methods (Static)
      function out = nextid()
         persistent maxid;
         if isempty(maxid)
             maxid = 0;
         end
         maxid = maxid+1;
         out = maxid;
      end
     end
    
    methods
         function obj = Variable(name,initvalue)
            obj = obj@DeepOp();
            obj.xid = obj.nextid();
            obj.name = name;
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
         
         function set(obj,value)
             obj.xvalue = value;
             obj.xshape = size(value);
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
             assert(numel(v) == 1 || all(size(v) == size(obj.xvalue)),'increment same size or scalar');
             obj.xvalue = obj.xvalue + v;
         end

         function grad(obj,v)
             assert(numel(v) == 1 || all(size(v) == size(obj.xvalue)),'gradient same size or scalar');
             obj.xgrad = obj.xgrad + v;
         end
         
         function gradshape(obj,up)
         end
         
         function g = getgrad(obj)
             g = obj.xgrad;
         end
         
    end
    
    
end

