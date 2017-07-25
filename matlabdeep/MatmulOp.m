classdef MatmulOp < BinaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = MatmulOp(a,b)
            obj = obj@BinaryOp(a,b);
        end
        
        function r = eval(obj)
            xl = obj.left.eval() ;
            xr = obj.right.eval();
            
            % why not? bsxfun(@times, xl,xr)
            obj.xvalue = xl*xr;
            r = obj.xvalue;
        end

         function r = evalshape(obj)
             xl = obj.left.evalshape();
             xr = obj.right.evalshape();
             r = [xl(1:end-1),xr(2:end)];
        end

        function grad(obj,up)
                % using Scale.m in vl_nnet
                inputs = obj.left.xvalue;
                params = obj.right.xvalue;
                args = horzcat(inputs,params);
                sz = [size(args{2}) 1 1 1 1] ;
                sz = sz(1:4) ;
                dargs{1} = bsxfun(@times, up, args{2}) ;
                dargs{2} = up .* args{1} ;
                for k = find(sz == 1)
                 dargs{2} = sum(dargs{2}, k) ;
                end
                derInputs = dargs(1:numel(inputs)) ;
                derParams = dargs(numel(inputs)+(1:numel(params))) ;
                obj.left.grad(derInputs);
                obj.right.grad(derParams);
        end
        
  

        function reset(obj)
            obj.left.reset();
            obj.right.reset();
        end

    end
    
end

