classdef DropoutOp < ElementWiseUnaryOp
    
    properties
        prob
    end

    properties (Transient)
        mask
    end

    methods
        function obj = DropoutOp(left,prob)
            obj = obj@ElementWiseUnaryOp(left);
            obj.prob = prob;
        end
        
        function x = eval(obj)
            x = obj.left.eval();
            rate = obj.prob.xvalue;
            if rate < 1.0                
                % see vl_nndropout
                %
                % scale is not 1 because we compensate for the reduction of
                % items in the weights
                %
                % in practice we should count the number of items
                q = (rand(size(x), 'single') >= rate);
                realrate = sum(q(:) == false)/numel(q);
                scale = single(1 / (1 - realrate));
                obj.mask = scale * q; 
                obj.xvalue = obj.mask .* x ;
            else
                obj.mask = [];
                obj.xvalue = x;
            end
        end
        
       
        function grad(obj,up)
            if isempty(obj.mask)
                obj.left.grad(up);
            else                
                obj.left.grad(up.*obj.mask);
            end
        end
       
    end
    
end

