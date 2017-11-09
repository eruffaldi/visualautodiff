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
        
        function r = evalshape(obj)
            sxl = obj.left.evalshape();
            sxr = obj.right.evalshape();
            % exactly
            if length(sxl) == length(sxr) && all(sxl == sxr)
                obj.broadcastmode = 0;
                obj.w = [];
            % always the first term
            % [a,b] + [a, 1]
            elseif length(sxl) == 2 && length(sxr) == 2 && sxr(2) == 1 && sxr(1) == sxl(1)
                obj.broadcastmode = 1;
                obj.w = sxr;
            % [a,b,c,d] + [a, 1]
            % xD + 1D with last dimension of xD == length of vector
            elseif length(sxl) > 2 && length(sxr) == 2 && sxr(2) == 1 && sxr(1) == sxl(1)
                obj.broadcastmode = 2;
                obj.w = [sxl(1) prod(sxl(2:end))];
            else
                error('unsupported broadcast mode in %s + %s',num2str(sxl(:)'),num2str(sxr(:)'));
            end                
            obj.xshape = sxl;
            r = obj.xshape;
        end

        function r = eval(obj)
            xl = obj.left.eval() ;
            xr = obj.right.eval();
            % r = bsxfun(@plus,a,b); 
            switch(obj.broadcastmode)
                case 0 % same
                    obj.xvalue = xl+xr;
                case 1 %  [a,b] + [a, 1]
                    obj.xvalue = xl+xr(:);
                case 2 %  [a,b,c,d] + [a, 1]
                    % input (C1,...K) ->reshaped ((C1...CK),K) -> broadcash
                    obj.xvalue = reshape(reshape(xl,obj.w) + xr,obj.left.xshape);                
                otherwise
                    error('not implemented');
            end
            r = obj.xvalue;
        end

        function grad(obj,up)
            assert(all(size(obj.left.xvalue)==size(up)));
            obj.left.grad(up); % always same size
            
            switch(obj.broadcastmode)
                case 0
                    upx = up;
                    % if not broadcast then it is just the input u
                case 1 %  [a,b] + [a, 1]
                    upx = sum(up,2);
                case 2 %  [a,b,c,d] + [a, 1]
                    upx = sum(reshape(up,obj.w),2);
                otherwise
                    error('not implemented');
                    upx = up;
            end                    
            obj.right.grad(upx);
        end

    end
    
end

