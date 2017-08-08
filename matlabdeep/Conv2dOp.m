classdef Conv2dOp < BinaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        stride
        matlabconv
        padding 
        shapeP
        Sel_PKC_IC
        shape_BP_KC
        xtype
        
        Xp_BP_KC
    end
    
    methods
        % [batch, in_height, in_width, in_channels]
        % [filter_height, filter_width, in_channels, out_channels]
        % We define the following:
        % B = batch
        % I = input space = Fh Fw C
        % K = kernel space = Kh Kw C (over which we do combination)
        % P = patch space = Ph Pw C  (the output)
        % C = input channels
        % Q = output channels
        %
        % We do the transformations (independent of shape):
        % - X input: B I
        % - Xp patches: B P C K
        % - Xo output: B P Q        
        function obj = Conv2dOp(x,W,stride,pad)
            assert(all(stride==1),'only stride 1');
            assert(strcmp(pad,'SAME'),'only pad SAME');
            assert(isa(W,'Variable'),'W should be variable');
            assert(length(W.xshape) == 4,'W should have 4D shape: K K 1 F');
            obj = obj@BinaryOp(x,W);
            obj.stride = stride;
            obj.matlabconv = 1;
            obj.padding = -1;
            obj.xtype = obj.setgetDefaultType();
        end
        
        function r = evalshape(obj)
            xl = obj.left.evalshape();
            xr = obj.right.evalshape();            
            assert(length(xl) == 4); % breaks if C=1
            assert(length(xr) == 4); % breaks if Q=1
            assert(xl(4) == xr(3),'in_channel same'); % W is: Fh Fw C Q
            nQ = xr(4);
            
            % Fh Fw Fi Fo
            h_filter = xr(1);
            w_filter = xr(2);
            padding = obj.padding;
            stride = obj.stride(1);
            if obj.padding == -1
                % automatic padding to satisfy requirement
                paddingh = (h_filter-1)/2;
                paddingw = (w_filter-1)/2;
            else
                % can break
                paddingh = padding;
                paddingw = padding;
            end
            [obj.Sel_PKC_IC,shape_BPKC,obj.shapeP] = mpatchprepare(xl,[h_filter w_filter],[stride stride],[paddingh,paddingw], 'BPKC'); % N independent
            
            obj.shape_BP_KC = [prod(shape_BPKC(1:2)), prod(shape_BPKC(3:5))];
            obj.xshape = [xl(1) obj.shapeP(1) obj.shapeP(2) nQ];
        end
        
        
        function r = eval(obj)
            A_B_I_C = obj.left.eval();
            W_K_C_Q = obj.right.eval();
            nQ = obj.xshape(4); 
            
            PA_BP_KC = mpatcher(A_B_I_C,obj.Sel_PKC_IC,obj.shape_BP_KC);             
            
            obj.Xp_BP_KC = PA_BP_KC; % for gradient
            obj.xvalue = reshape(PA_BP_KC*reshape(W_K_C_Q,[],nQ),obj.xshape); % B_Ph_Pw_Q
            r = obj.value;
        end
        
        
        function grad(obj,U_B_Ph_Pw_Q)
            nB = obj.left.xshape(1);
            nP = obj.xshape(2)*obj.xshape(3);
            nQ = size(U_B_Ph_Pw_Q,4);
            U_BP_Q = reshape(U_B_Ph_Pw_Q,nB*nP,nQ); % B_Ph_Pw_Q => BP_Q
            
            % work using matrix product in flat space [B P, K C] [K C, Q]
            %   d/dA A W = U W'   [B P, Q] [K C, Q]
            %   d/dW A W = A' U
            W_K_C_Q = obj.right.xvalue;
            dzdx_BP_KC = U_BP_Q * reshape(W_K_C_Q,[],nQ)';
            dzdx_B_PKC  = reshape(dzdx_BP_KC,nB*nP,[]);
            dzdx = munpatcher(dzdx_B_PKC,obj.Sel_PKC_IC,obj.left.xshape);
            obj.left.grad(dzdx);

            dzdW = reshape(obj.Xp_BP_KC' * U_BP_Q,obj.right.xshape);          
            obj.right.grad(dzdW);
        end
        
    end
    
end

