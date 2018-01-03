classdef Variable < DeepOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        initvalue
        xid
        xtype
        gshape
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
            obj.xtype = DeepOp.setgetDefaultType();
            if isa(initvalue,'function_handle')
                v = initvalue();
            else
                 initvalue = cast(initvalue,'like',obj.xtype);
                v = initvalue;
            end
            obj.xvalue = v;
            obj.xshape = size(v);
            % xgrad unknown until target size is known in gradshape
            %obj.xgrad = mzeros(obj.xshape,obj.xtype);
         end
         
         function r = evalshape(obj)
             r = obj.xshape;
         end
         
         function gradshape(obj,ts)
             obj.ts = ts;
             obj.gshape = [obj.xshape,ts.fullshape];
         end

         function resetgrad(obj)             
             obj.xgrad = mzeros(obj.gshape,obj.xtype);
         end
         
         function set(obj,value)
             obj.xvalue = cast(value,'like',obj.xtype);
             obj.xshape = size(value);
         end

        function resetvalue(obj)             
            if isa(obj.initvalue,'function_handle')
                v = obj.initvalue();

                v = cast(v,'like',obj.xtype);
            else
                v = obj.initvalue;
            end
            obj.xvalue = v;
            obj.xshape = size(v);
            obj.xgrad = mzeros(obj.gshape,obj.xtype);
         end

         function reset(obj)             
            % no reset
            obj.resetgrad();
         end
        
         function r = eval(obj)
             r = obj.xvalue;
         end

         function increment(obj,v)
             assert(numel(v) == 1 || all(size(v) == size(obj.xvalue)),'increment same size or scalar');
             obj.xvalue = obj.xvalue + cast(v,'like',obj.xtype);
         end

         function grad(obj,v)
             assert(numel(v) == 1 || all(size(v) == size(obj.xvalue)),'gradient same size or scalar');
             if isempty(obj.ts)
                 obj.xgrad = obj.xgrad + cast(v,'like',obj.xtype);
             else
                 error('Variable grad for non empty ts not specified');
             end
         end
         
         function g = getgrad(obj)
             g = obj.xgrad;
         end
         
    end
    
    
end

