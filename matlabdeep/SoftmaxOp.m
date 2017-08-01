classdef SoftmaxOp < UnaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        axis
    end
    
    methods
        function obj = SoftmaxOp(a)
            obj = obj@UnaryOp(a);
            obj.axis = 2;
        end
        
        function r = eval(obj)
            X = obj.left.eval();
            
            % Copyright vl_nnsoftmax
            E = exp(bsxfun(@minus, X, max(X,[],obj.axis))) ;
            L = sum(E,obj.axis) ;
            r = bsxfun(@rdivide, E, L) ;
            obj.xvalue = r;
        end

        function r = evalshape(obj)
            obj.xshape = obj.left.evalshape();
            r = obj.xshape;
        end

        function grad(obj,up)
            % Copyright vl_nnsoftmax
            dzdY = up;
            Y = obj.xvalue;
            dY = Y .* bsxfun(@minus, dzdY, sum(dzdY .* Y, obj.axis));
            obj.left.grad(dY);
        end

    end
    
end

