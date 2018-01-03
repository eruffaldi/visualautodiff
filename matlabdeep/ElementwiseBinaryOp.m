classdef ElementwiseBinaryOp < BinaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        broadcastmode
        w
        w1
    end
    
    methods
         function obj = ElementwiseBinaryOp(left,right)
            obj = obj@BinaryOp(left,right);
            obj.broadcastmode = 0;
         end

                 % given right up sizes it
         function r = upsizediv(obj,xl,xr)
            % r = bsxfun(@plus,a,b); 
            switch(obj.broadcastmode)
                case 0 % same
                    r = xl./xr;
                case 1 %  [a,b] + [a, 1]
                    r = xl./xr(:);
                case 2 %  [a,b,c,d] + [a, 1]
                    % input (C1,...K) ->reshaped ((C1...CK),K) -> broadcash
                    r = reshape(reshape(xl,obj.w) ./ xr,obj.left.xshape);                
                otherwise
                    error('not implemented');
            end
         end
         function upx = downsizesum(obj,up)
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
         end
        % given right up sizes it
         function r = upsizemul(obj,a,b)
            % r = bsxfun(@plus,a,b); 
            switch(obj.broadcastmode)
                case 0 % same
                    r = xl.*xr;
                case 1 %  [a,b] + [a, 1]
                    r = xl.*xr(:);
                case 2 %  [a,b,c,d] + [a, 1]
                    % input (C1,...K) ->reshaped ((C1...CK),K) -> broadcash
                    r = reshape(reshape(xl,obj.w) .* xr,obj.left.xshape);                
                otherwise
                    error('not implemented');
            end    
         end
         
        % given right up sizes it
         function r = upsizesum(obj,a,b)
                        % r = bsxfun(@plus,a,b); 
            switch(obj.broadcastmode)
                case 0 % same
                    r = xl+xr;
                case 1 %  [a,b] + [a, 1]
                    r = xl+xr(:);
                case 2 %  [a,b,c,d] + [a, 1]
                    % input (C1,...K) ->reshaped ((C1...CK),K) -> broadcash
                    r = reshape(reshape(xl,obj.w) + xr,obj.left.xshape);                
                otherwise
                    error('not implemented');
            end          
         end         
         % given right up sizes it
         function r = upsize(obj,x)
            % r = bsxfun(@plus,a,b); 
            switch(obj.broadcastmode)
                case 0 % same
                    r = x;
                case 1 %  [a,b] + [a, 1]
                    error('not implemented')
                    r = x(:);
                case 2 %  [a,b,c,d] + [a, 1]
                    % manual broad cast
                    error('not implemented')
                otherwise
                    error('not implemented');
            end             
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

        function gradshape(obj,ts)
            obj.left.gradshape(ts);
            obj.right.gradshape(ts);
        end

    end
    
end
