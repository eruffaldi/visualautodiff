classdef DropoutOp < UnaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        prob
    end

    properties (Transient)
        mask
    end

    methods
        function obj = DropoutOp(left,prob)
            obj = obj@UnaryOp(left);
            obj.prob = prob;
        end
        
        function x = eval(obj)
            x = obj.left.eval();
            rate = obj.prob.xvalue;
            if rate < 1.0                
                scale = single(1 / (1 - rate));
                obj.mask = scale * (rand(size(x), 'single') >= rate); 
                x = obj.mask .* x ;
                %[outputs{1}, obj.mask] = vl_nndropout(inputs{1}, 'rate', obj.rate) ;                
            else
                obj.mask = [];
            end
            obj.xvalue = x;
        end
        
        function r = evalshape(obj)
            obj.xshape = obj.left.evalshape();
            r = obj.xshape;
        end
        
        function grad(obj,up)
            if isempty(obj.mask)
                obj.left.grad(up);
            else                
                obj.left.grad(up.*obj.mask);
            end
        end
        
        function gradshape(obj,up)
            obj.left.gradshape(up);
        end
    end
    
end

