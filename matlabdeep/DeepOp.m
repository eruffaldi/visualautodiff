classdef (Abstract) DeepOp < handle
    
    properties
        xvalue
        xshape
        xgrad
        name
        ts
    end
    
    methods (Abstract)        
        eval(obj)
        evalshape(obj)
        grad(obj,up)
        gradshape(obj,ts)
    end   
    
    methods
        function r = evalwith(obj,placeholders)
            sa = isempty(obj.xshape);
            for I=1:2:length(placeholders)
                sa = sa | placeholders{I}.set(placeholders{I+1});
            end
            if sa ~= 0
                obj.evalshape();
                obj.ts = TargetSpec.makeFull(obj.xshape);
                obj.gradshape(obj.ts);
            end
            obj.reset();
            r = obj.eval();
        end

        function r = evalshapewith(obj,placeholders)
            sa = 0;
            for I=1:2:length(placeholders)
               sa = sa | placeholders{I}.set(placeholders{I+1});
            end
            if sa ~= 0
                obj.evalshape();
                obj.ts = TargetSpec.makeFull(obj.xshape);
                obj.gradshape(obj.ts);
            end
        end
        
        % call this after
        function evalgrad(obj)
            if numel(obj.xshape) == 1
                obj.grad(1,[]);
            else
                obj.grad(mones(obj.xshape,DeepOp.setgetDefaultType()));
            end
        end

        function reset(obj)
        end
        
        function visit(obj,fx)
            fx(obj);
        end

        function r = plus(a,b)
            % TODO make b a ConstantOp
            assert(isa(a,'DeepOp'));
            if(isa(b,'DeepOp') == 0)
                b = ConstantOp(b);
            end
            r = AddOp(a,b);
        end

        function r = divide(a,b)
            % TODO make b a ConstantOp
            assert(isa(a,'DeepOp'));
            if(isa(b,'DeepOp') == 0)
                b = ConstantOp(b);
            end
            r = DivOp(a,b);
        end

        function r = times(a,b)
            % TODO make b a ConstantOp
            assert(isa(a,'DeepOp'));
            if(isa(b,'DeepOp') == 0)
                b = ConstantOp(b);
            end
            r = MulOp(a,b);
        end

        function r = mtimes(a,b)
            assert(isa(a,'DeepOp'));
            if(isa(b,'DeepOp') == 0)
                b = ConstantOp(b);
            end
            r = MatmulOp(a,b);            
        end
        
        function r = tanh(a)
            r= TanhOp(a);
        end
        
        
        function r = sigmoid(a)
            r= SigmoidOp(a);
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

