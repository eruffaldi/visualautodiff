classdef SoftmaxOp < UnaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function obj = SoftmaxOp(a)
            obj = obj@UnaryOp(a);
        end
        
        function r = eval(obj)
            X = obj.left.eval();
            
            % Copyright vl_nnsoftmax
            E = exp(bsxfun(@minus, X, max(X,[],3))) ;
            L = sum(E,3) ;
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
            Y = Y .* bsxfun(@minus, dzdY, sum(dzdY .* Y, 3));
            obj.left.grad(up);
        end

    end
    
end

