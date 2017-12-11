classdef OneHotOp < ElementWiseUnaryOp
    % missing gradient
    
    properties
        num_classes
        classes_in_first
    end
    methods
        function obj = OneHotOp(a,num_classes,classes_in_first)
            obj = obj@ElementWiseUnaryOp(a);
            obj.classes_in_first = classes_in_first;
            obj.num_classes = num_classes;
        end

        function r = evalshape(obj)
            obj.left.evalshape();
            xs = obj.left.xshape;
            if obj.classes_in_first
                xs = [obj.num_classes,xs];
            else
                xs = [xs,obj.num_classes];
            end
            r = xs;
            obj.xshape = xs;                
        end

        function r = eval(obj)
            x = obj.left.eval();
            if obj.classes_in_first
                r = mzeros([obj.num_classes,prod(obj.xshape(2:end))],x);
                r(sub2ind(size(x),x(:),1:numel(x))) = 1;
            else
                r = mzeros([prod(obj.xshape(1:end-1)),obj.num_classes],x);                
                r(sub2ind(size(x),1:numel(x),x(:))) = 1;
            end
            r = reshape(r,obj.xshape);
        end

        function grad(obj,up)
            % should we implement this? 
        end

    end
    
end

