classdef Conv2dOp < BinaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        stride
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
        end
        
        function r = eval(obj)
            A = obj.left.eval();
            W = obj.right.eval();
            xs = obj.left.xshape;
            r = mzeros(obj.xshape);
            for iB=1:xs(1)
                for iC=1:xs(4) 
                    r(iB,:,:,iC) = conv2(A(iB,:,:,iC),W,'same');
                end
            end
            obj.xvalue = r;
        end
        
        function r = evalshape(obj)
            xl = obj.left.evalshape();
            xr = obj.right.evalshape();
            assert(length(xl) == 4);
            assert(length(xr) == 4);
            assert(xl(4) == xr(3),'in_channel same');
            
            % assuming stride 1 
            obj.xshape = [xl(1) xl(2) xl(3) xr(4)]; 
            r = obj.xshape;
        end
        
        function grad(obj,up)
            % See http://deeplearning.net/software/theano/tutorial/conv_arithmetic.html
            
            % special case of seed=1 and pad=SAME
            %
            % the gradient is the sum of the image?
            dzdx = zeros(1);
            dzdW = zeros(1);
            for iB=1:xs(1)
                for iC=1:xs(4) 
                    
                end
            end
            
            obj.left.grad(dzdx);
            obj.right.grad(dzdW);
        end
        
    end
    
end

