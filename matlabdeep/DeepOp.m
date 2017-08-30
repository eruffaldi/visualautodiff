classdef (Abstract) DeepOp < handle
    
    properties
        xvalue
        xshape
        xgrad
        name
    end
    
    methods (Abstract)        
        eval(obj)
        evalshape(obj)
        grad(obj,up)
        gradshape(obj,up)
    end   
    
    methods
        function r = evalwith(obj,placeholders)
            obj.reset();
            sa = 0;
            for I=1:2:length(placeholders)
                sa = sa | placeholders{I}.set(placeholders{I+1});
            end
            if sa ~= 0
                obj.evalshape();
            end
            r = obj.eval();
        end

        function r = evalshapewith(obj,placeholders)
            obj.reset();
            sa = 0;
            for I=1:2:length(placeholders)
               sa = sa | placeholders{I}.set(placeholders{I+1});
            end
            if sa ~= 0
                obj.evalshape();
            end
        end

        function reset(obj)
        end
        
        function visit(obj,fx)
            fx(obj);
        end

        function r = plus(a,b)
            assert(isa(a,'DeepOp'));
            assert(isa(b,'DeepOp'));
            r = AddOp(a,b);
        end

        function r = mtimes(a,b)
            assert(isa(a,'DeepOp'));
            assert(isa(b,'DeepOp'));
            r = MatmulOp(a,b);            
        end
        
        

    end
    
    methods (Static)
      function out = setgetDefaultType(data)
         persistent Var;
         if nargin
            Var = data;
         else
             if isempty(Var)
                 Var = double(0);
             end
         end
         out = Var;
      end
   end
    
end

