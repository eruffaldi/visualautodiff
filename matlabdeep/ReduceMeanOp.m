classdef ReduceMeanOp < UnaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        axis 
    end
    
    methods
        % only full reduction
        function obj = ReduceMeanOp(x,axis)            
            obj = obj@UnaryOp(x);
            obj.axis = axis;
        end
        
        function r = eval(obj)
            x = obj.left.eval();
            if obj.axis == 0
                r = mean(x(:));
            else
                r = squeeze(mean(x,obj.axis));
            end
            obj.xvalue = r;
        end
        
        function r = evalshape(obj)
            obj.left.evalshape();
            if obj.axis == 0
                obj.xshape = 1;
            else
                % remove the given axis
                s = obj.left.xshape;
                s(obj.axis) = [];
                obj.xshape = s;
            end
            r = obj.xshape;
        end
        
        function grad(obj,up)
            % f = sum x(ijkl) / N
            % df/dx = 1/N
            if obj.axis == 0
                obj.left.grad((up/numel(obj.left.xvalue))); %*mones(obj.left.xshape));
            else
                error('not implemented');
            end
                
        end        
    end
    
end

