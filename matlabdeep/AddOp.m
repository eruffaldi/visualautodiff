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
                case 0 % same
                    obj.xvalue = xl+xr;
                case 1 %  2D + 1D row using broadcast 
                    obj.xvalue = xl+xr;
                case 2 %  2D + 1D col
                    obj.xvalue = xl+xr';
                case 3 %  xD + 1D with last shared
                    % input (C1,...K) ->reshaped ((C1...CK),K) -> broadcash
                    obj.xvalue = reshape(reshape(xl,obj.w) + xr(:)',obj.left.xshape);
                otherwise
                    error('not implemented');
            end
            r = obj.xvalue;
        end

        function r = evalshape(obj)
            sxl = obj.left.evalshape();
            sxr = obj.right.evalshape();
            if length(sxl) == length(sxr) && all(sxl == sxr)
                obj.broadcastmode = 0;
                obj.w = [];
            % 2D + 1D row            
            elseif length(sxl) == 2 && length(sxr) == 2 && sxr(1) == 1
                obj.broadcastmode = 1;
                obj.w = [sxl(1) sxr(2)];
            % 2D + 1D col
            elseif length(sxl) == 2 && length(sxr) == 2 && sxr(2) == 2
                obj.broadcastmode = 2;
                obj.w = [sxl(1) sxr(2)];
            % xD + 1D with last dimension of xD == length of vector
            elseif length(sxl) > 2 && length(sxr) == 2 && min(sxr) == 1 && max(sxr) == sxl(end)
                obj.broadcastmode = 3;
                obj.w = [prod(sxl(1:end-1)) sxl(end)];
            else
                error('unsupported broadcast mode in AddOp %s %s',num2str(sxl(:)'),num2str(sxr(:)'));
            end                
            obj.xshape = sxl;
            r = obj.xshape;
        end

        function grad(obj,up)
            obj.left.grad(up); % always same size
            
            switch(obj.broadcastmode)
                case 0
                    % if not broadcast then it is just the input u
                case 1 %  2D + 1D row using broadcast 
                    up = sum(reshape(up,obj.w),1);
                case 2 %  2D + 1D col
                    up = sum(reshape(up,obj.w),1);
                case 3 %  xD + 1D with last shared
                    up = sum(reshape(up,obj.w),1);
                otherwise
                    error('not implemented');
            end                    
            obj.right.grad(up);
        end

    end
    
end

