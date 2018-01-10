classdef MatmulOp < BinaryOp
    
    methods
        function obj = MatmulOp(a,b)
            obj = obj@BinaryOp(a,b);
        end
        
        function r = eval(obj)
           xl = obj.left.eval();
           xr = obj.right.eval();
            
            obj.xvalue = xl*xr;
            r = obj.xvalue;
        end

         function r = evalshape(obj)
             xl = obj.left.evalshape();
             xr = obj.right.evalshape();
             assert(length(xl) == 2 & length(xr) == 2,'only 2D');
             r = [xl(1:end-1),xr(2:end)];
         end


        % Generalized
        % [M, N] [N, K]
        % [O1..On 

        % assuming 2D cases: 
       %
        % then up ~= [M, K]
        % gradient as same size
        % 
        %   gradient for right:  A' up = [N, M] [M, K]  = [N, K]
        %            for left:   up B'  = [M, K] [K, N] = [M, N]
        function grad(obj,up)
            xl = obj.left.xvalue;
            xr = obj.right.xvalue;
               
            obj.left.grad(up*xr');
            obj.right.grad(xl'*up);
        end
    
                function r = gradshape(obj,up)
        end
        

    end
    
end

