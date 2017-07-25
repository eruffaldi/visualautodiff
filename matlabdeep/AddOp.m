classdef AddOp < DeepOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        left
        right
    end
    
    methods
        function obj = AddOp(a,b)
            obj = obj@DeepOp();
            obj.left = a;
            obj.right = b;
        end
        
        function r = eval(obj)
            xl = obj.left.eval() ;
            xr = obj.right.eval();
            sxl = size(xl);
            disp('AddOp')
            size(xl)
            size(xr)
            if length(xr) == length(xl) && all(size(xl) == size(xr))
                obj.xvalue = xl+xr;
            else
                xld = ndims(xl);
                if size(xr,2) == 1 & size(xl,xld) == size(xr,1)
                    % [a1..ak b] + [b 1]
                    w = size(xl);
                    w(end) = 1;
                    w1 = ones(1,length(xl));
                    w1(end) = size(xr,1);
                    obj.xvalue = xl + repmat(reshape(xr,w1),w);
                elseif size(xr,1) == 1 & size(xl,xld) == size(xr,2)
                    % [a1..ak b] + [1 b]
                    w = size(xl);
                    w(end) = 1;
                    w1 = ones(1,ndims(xl));
                    w1(end) = size(xr,2);
                    obj.xvalue = xl + repmat(reshape(xr,w1),w);
                end
            end
            r = obj.xvalue;
        end

        function r = evalshape(obj)
            sl = obj.left.evalshape();
            sr = obj.right.evalshape();
            obj.xshape =sl;
            r = obj.xshape;
        end

        function grad(obj,up)
            obj.left.grad(up);
            obj.right.grad(up);
        end

        function gradshape(obj,up)
            obj.left.gradshape(up);
            obj.right.gradshape(up);
        end

         function reset(obj)
            obj.left.reset()
            obj.right.reset();
         end
        
    end
    
end

