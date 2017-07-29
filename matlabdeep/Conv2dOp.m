classdef Conv2dOp < BinaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        stride
        matlabconv
        padding 
    end
    
    methods
        % [batch, in_height, in_width, in_channels]
        % [filter_height, filter_width, in_channels, out_channels]
        function obj = Conv2dOp(x,W,stride,pad)
            assert(all(stride==1),'only stride 1');
            assert(strcmp(pad,'SAME'),'only pad SAME');
            assert(isa(W,'Variable'),'W should be variable');
            assert(length(W.xshape) == 4,'W should have 4D shape: K K 1 F');
            obj = obj@BinaryOp(x,W);
            obj.stride = stride;
            obj.matlabconv = 1;
            obj.padding = -1;
        end
        
        function r = eval(obj)
            A = obj.left.eval();
            W = obj.right.eval();
            xs = obj.left.xshape;
            r = mzeros(obj.xshape);
            
%             if obj.matlabconv == 1
%                 % for every input
%                 % for every input channel
%                 % for every output
%                 for iB=1:xs(1)
%                     for iC=1:xs(4) 
%                         r(iB,:,:,iC) = conv2(squeeze(A(iB,:,:,iC)),W(:,:,,'same');
%                     end
%                 end
%             end
            obj.xvalue = r;
        end
        
        function r = evalshape(obj)
            xl = obj.left.evalshape();
            xr = obj.right.evalshape();
            assert(length(xl) == 4);
            assert(length(xr) == 4);
            assert(xl(4) == xr(3),'in_channel same');
            
            % General case
            h_x = xl(2);
            w_x = xl(3);
            h_filter = xr(2);
            w_filter = xr(3);
            padding = obj.padding;
            stride = obj.stride(1);
            if obj.padding == -1
                paddingh = (h_filter-1)/2;
                paddingw = (w_filter-1)/2;
            else
                paddingh = padding;
                paddingw = padding;
            end
                
            h_out = floor((h_x - h_filter + 2 * paddingh) / stride + 1);
            w_out = floor((w_x - w_filter + 2 * paddingw) / stride + 1);
            assert(all([h_out,w_out] > 0),'all output should be positive');
            w_out = max(1,w_out);
            h_out = max(1,h_out);
            % assuming stride 1 
            obj.xshape = [xl(1) h_out w_out xr(end)];
            r = obj.xshape;
        end
        
        function grad(obj,up)
            dzdx = mzeros(obj.left.xshape);
            dzdW = mzeros(obj.right.xshape);
            
            
            obj.left.grad(dzdx);
            obj.right.grad(dzdW);
        end
        
    end
    
end

