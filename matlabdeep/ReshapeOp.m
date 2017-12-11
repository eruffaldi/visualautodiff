classdef ReshapeOp < UnaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        eshape
    end
    
    methods
        % s can be shape with some -1 somewhere
        % s can be: 'last', 'first' so that we emulate batch_flatten
        %
        % Matlab ISSUE: if the input shape is 1 the dimensions are reduced e.g. [3,1,1,1] => [3,1]      
        function obj = ReshapeOp(a,s)
            obj = obj@UnaryOp(a);
            obj.eshape = s;
        end
            
        function r = evalshape(obj)
            xs = obj.left.evalshape();
            if strcmp(s,'last')
                obj.xshape = [prod(xs(1:end-1)) xs(1)];                
            elseif strcmp(s,'first')
                obj.xshape = [xs(1) prod(xs(2:end)) ];                
            else
                if obj.eshape(1) == -1
                    obj.xshape = [xs(1) obj.eshape(2:end)];
                elseif obj.eshape(end) == -1
                    obj.xshape = [obj.eshape(1:end-1) xs(end)];
                else
                    obj.xshape = obj.eshape;
                end
                % make it row
                if length(obj.xshape) == 1
                    obj.xshape = [obj.xshape,1];
                end
            end
            r = obj.xshape;
        end
        
        function r = eval(obj)  
            xl = obj.left.eval();
            obj.xvalue = reshape(xl,obj.xshape);
            r = obj.xvalue;
            assert(~isempty(r));
        end
        
        function grad(obj,up)
            obj.left.grad(reshape(up,obj.left.xshape));
        end
        
    end
    
end

