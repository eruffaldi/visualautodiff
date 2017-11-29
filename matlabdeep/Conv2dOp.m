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
        Xp_BP_KC
        xtype
        colmajor

        Sel_IC_CKP
shape_CK_PB
        Xp_CK_PB
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
        function obj = Conv2dOp(x,W,stride,pad,colmajor)
            if nargin < 5
                colmajor = 1;
            end
            assert(all(stride==1),'only stride 1');
            assert(strcmp(pad,'SAME'),'only pad SAME');
            assert(isa(W,'Variable') || isa(W,'Placeholder'),'W should be variable or placeholder');
            assert(length(W.xshape) <= 4,'W should have maximum 4D shape');
            obj = obj@BinaryOp(x,W);
            obj.stride = stride;
            obj.matlabconv = 0;
            obj.padding = -1;
            obj.colmajor = colmajor;
            obj.xtype = obj.setgetDefaultType();
        end
        
        % Col Major: 
        %  C Iw Ih B
        %  Q C Fw Fh
        % Row Major
        %   B Ih Iw C
        %   Fh Fw C Q
        function r = evalshape(obj)
            xr = oneextend4(obj.right.evalshape());
           
            xl =oneextend4(obj.left.evalshape());
                        
            if obj.colmajor
                flipper = @(x) x(end:-1:1);
                inmode = 'CWHB';
                procmode = 'ChwWHB';
            else
                flipper = @(x) x;
                inmode = 'BHWC';
                procmode = 'BHWwhC';
            end
            
            xll = flipper(xl);
            xrr = flipper(xr);
            h_filter = xrr(1);
            w_filter = xrr(2);
            nCw = xrr(3); % Fout Fin w h
            nQ = xrr(4);
            
            nB = xll(1);
            nCi = xll(4);

            assert(nCi == nCw,'same color input of kernel');
            h_image =  xll(2);
            w_image = xll(3);

            
            
            if obj.padding ~= -1
                obj.matconv = 0;
            end
            
            [padding,sizeout,offsetout] = paddingsetup([h_image w_image],[h_filter,w_filter],obj.stride(2:3),obj.padding);
            mm = mpatchprepare(inmode,xl,[h_filter w_filter],sizeout,obj.stride,padding,procmode,obj.colmajor); % N independent
            preshape = [nB*mm.outshape.W*mm.outshape.H,mm.outshape.w*mm.outshape.h*mm.outshape.C];
            
            if obj.colmajor
                obj.shape_CK_PB = flipper(preshape);
                obj.Sel_IC_CKP = mm;
            else                
                obj.shape_BP_KC = preshape;
                obj.Sel_PKC_IC = mm;
            end
            obj.xshape = flipper([nB mm.outshape.H mm.outshape.W nQ]);
            r = obj.xshape;
        end
        
        
        function r = eval(obj)
            if obj.colmajor
                A_C_I_B = obj.left.eval();
                W_Q_C_K = obj.right.eval();
                nQ = obj.xshape(1); 

                PA_CK_PB = mpatcher(A_C_I_B,obj.Sel_IC_CKP,obj.shape_CK_PB,obj.colmajor);             

                obj.Xp_CK_PB = PA_CK_PB; % for gradient
                if obj.matlabconv
                    % given left: ACIB right: WQCK convolution with same size
                    % outputs: A Q I B
                    %
                    obj.xvalue = zeros(obj.xshape,'like',obj.left.xvalue);
                    for I=1:size(obj.xvalue,4)
                        for J=1:size(obj.xvalue,1)
                            q = squeeze(sum(convn(W_Q_K_C(J,:,:,:), A_C_I_B(:,:,:,I),'same'),1));
                            obj.xvalue(J,:,:,I) =  reshape(q,[1,size(q,1),size(q,2),1]);
                        end
                    end
                else
                    obj.xvalue = reshape(reshape(W_Q_C_K,nQ,[])*PA_CK_PB,obj.xshape);
                end
            else
                A_B_I_C = obj.left.eval();
                W_K_C_Q = obj.right.eval();
                nQ = obj.xshape(4); 

                PA_BP_KC = mpatcher(A_B_I_C,obj.Sel_PKC_IC,obj.shape_BP_KC,0);             

                obj.Xp_BP_KC = PA_BP_KC; % for gradient
                if obj.matlabconv
                    % given left: ABIC right: WKCQ convolution with same size
                    % outputs: A B I Q
                    %
                    obj.xvalue = zeros(obj.xshape,'like',obj.left.xvalue);
                    for I=1:size(obj.xvalue,1)
                        for J=1:size(obj.xvalue,4)
                            q = squeeze(sum(convn(A_B_I_C(I,:,:,:),W_K_C_Q(:,:,:,J),'same'),4));
                            obj.xvalue(I,:,:,J) =  reshape(q,[1,size(q,1),size(q,2),1]);
                        end
                    end
                else
                    obj.xvalue = reshape(PA_BP_KC*reshape(W_K_C_Q,[],nQ),obj.xshape); % B_Ph_Pw_Q
                end
            end
            r = obj.xvalue;
        end
        
        
        function grad(obj,in)
            if obj.colmajor
                U_Q_Pw_Ph_B = in;
                nB = obj.xshape(end);
                nP = size(U_Q_Pw_Ph_B,2)*size(U_Q_Pw_Ph_B,3);
                nQ = size(U_Q_Pw_Ph_B,1);
                U_Q_PB = reshape(U_Q_Pw_Ph_B,nQ,nB*nP); % B_Ph_Pw_Q => BP_Q

                % work using matrix product in flat space [B P, K C] [K C, Q]
                %   d/dA A W = U W'   [B P, Q] [K C, Q]
                %   d/dW A W = A' U
                W_Q_C_K = obj.right.xvalue;
                dzdx_CK_PB = reshape(W_Q_C_K,nQ,[])'*U_Q_PB;
                dzdx_CKP_B  = reshape(dzdx_CK_PB,[],nB*nP);
                dzdx = munpatcher(dzdx_CKP_B,obj.Sel_IC_CKP,obj.left.xshape,prod(obj.left.xshape(1:end-1)),obj.colmajor);
                obj.left.grad(dzdx);

                dzdW = reshape(U_Q_PB * obj.Xp_CK_PB',obj.right.xshape);          
                obj.right.grad(dzdW);            
            else
                U_B_Ph_Pw_Q = in;
                nB = obj.left.xshape(1);
                nP = size(U_B_Ph_Pw_Q,2)*size(U_B_Ph_Pw_Q,3);
                nQ = size(U_B_Ph_Pw_Q,4);
                U_BP_Q = reshape(U_B_Ph_Pw_Q,nB*nP,nQ); % B_Ph_Pw_Q => BP_Q

                % work using matrix product in flat space [B P, K C] [K C, Q]
                %   d/dA A W = U W'   [B P, Q] [K C, Q]
                %   d/dW A W = A' U
                W_K_C_Q = obj.right.xvalue;
                dzdx_BP_KC = U_BP_Q * reshape(W_K_C_Q,[],nQ)';
                dzdx_B_PKC  = reshape(dzdx_BP_KC,nB*nP,[]);
                dzdx = munpatcher(dzdx_B_PKC,obj.Sel_PKC_IC,obj.left.xshape,prod(obj.left.xshape(2:end)),0);
                obj.left.grad(dzdx);

                dzdW = reshape(obj.Xp_BP_KC' * U_BP_Q,obj.right.xshape);          
                obj.right.grad(dzdW);
            end
        end
        
    end
    
end

