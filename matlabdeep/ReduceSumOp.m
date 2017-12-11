classdef ReduceSumOp < UnaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        axis 
        keepdim
    end
    
    methods
        % only full reduction
        function obj = ReduceSumOp(x,axis,keepdim)            
            obj = obj@UnaryOp(x);
            if nargin < 3
                obj.keepdim = 0;
            else
                obj.keepdim = keepdim;
            end
            obj.axis = axis;
        end
        
        function r = eval(obj)
            x = obj.left.eval();
            if obj.axis == 0
                r = sum(x(:));
            else
                r = squeeze(sum(x,obj.axis));
                if obj.keepdim
                    r = reshape(r,obj.xshape); % otherwise sum is already == obj.xshape
                end
            end
        end
        
        function r = evalshape(obj)
            obj.left.evalshape();
            if obj.axis == 0
                obj.xshape = 1;
            else
                if obj.keepdim
                    r(obj.axis) = 1;
                    obj.xshape = r;
                else
                    % remove the given axis
                    s = obj.left.xshape;
                    s(obj.axis) = [];
                    obj.xshape = s;
                end
            end
            r = obj.xshape;
        end
        
        function grad(obj,up)
            % f = sum x(ijkl) / N
            % df/dx = 1/N
            if obj.axis == 0
                obj.left.grad(up); %*mones(obj.left.xshape));
            else
                if obj.axis == 1
                    oo = repmat(up,obj.left.xshape(obj.axis),1);
                    obj.left.grad(oo);
                else
                    oo = repmat(up',1,obj.left.xshape(obj.axis));
                    obj.left.grad(oo);
                end
            end
                
        end        
    end
    
end

