classdef AddOp < BinaryOp

    properties
        broadcastmode
        w
        w1
    end
    
    methods
        function obj = AddOp(a,b)
            obj = obj@BinaryOp(a,b);
            obj.broadcastmode = 0;
        end
        
        function r = eval(obj)
            xl = obj.left.eval() ;
            xr = obj.right.eval();
            % r = bsxfun(@plus,a,b); 
            switch(obj.broadcastmode)
                case 0
                    obj.xvalue = xl+xr;
                otherwise
                   % obj.xvalue = xl + repmat(reshape(xr,obj.w1),obj.w);
                   if(size(xl,2) == size(xr,2))
                       obj.xvalue = xl+xr;
                   else
                   obj.xvalue = xl + xr';
                   end
            end
            r = obj.xvalue;
        end

        function r = evalshape(obj)
            sxl = obj.left.evalshape();
            sxr = obj.right.evalshape();
            if length(sxl) == length(sxr) && all(sxl == sxr)
                obj.broadcastmode = 0;
            elseif sxr(2) == 1 & sxl(end) == sxr(1)
                obj.broadcastmode = -1;
                % [a1..ak b] + [b 1]
                w = sxl;
                w(end) = 1;
                w1 = ones(1,length(sxl));
                w1(end) = sxr(1);
                obj.w = w;
                obj.w1 = w1;
            elseif sxr(1) == 1 & sxl(end) == sxr(2)
                obj.broadcastmode = 1;
                % [a1..ak b] + [1 b]
                w = sxl;
                w(end) = 1;
                w1 = ones(1,length(sxl));
                w1(end) = sxr(2);
                obj.w = w;
                obj.w1 = w1;
            else
                sxl
                sxr
                error('unsupported AddOp broadcast');
            end
                
            obj.xshape =sxl;
            r = obj.xshape;
        end

        function grad(obj,up)
            % Assumption: left is always FULL size
            obj.left.grad(up);
            
            % Then: right can have smaller size
            switch(obj.broadcastmode)
                case 0
                    % if not broadcast then it is just the input u
                otherwise
                    % up = [a1 ... a2 b]
                    % xr = [b 1] or [1 b]
                    %
                    % we need to sum up all the first dimensions
                    % MAYBE RESHAPE
                    %y = up;
                    %for I=1:ndims(y)-1
                    %    y = sum(y,I);
                    %end
                   % up = reshape(y,size(obj.right.xvalue));
                    if obj.right.xshape(1) == 1
                        up = sum(up,1);
                    else
                        up = sum(up,1)';
                    end
                    assert(all(size(up)==obj.right.xshape),'preserve size');
                    
            end                    
            obj.right.grad(up);
        end

        function gradshape(obj,up)
            obj.left.gradshape(up);
            obj.right.gradshape(up);
        end

    end
    
end

