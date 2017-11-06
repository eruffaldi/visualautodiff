classdef conv2d_grad < matlab.System & matlab.system.mixin.Propagates
    % untitled2 Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties(Nontunable)

    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(Access = private)
        
    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
        end
        

        function [dzdx_Q_Pw_Ph_B,dzdQ_C_K_W]= isOutputFixedSizeImpl(obj)
            dzdx_Q_Pw_Ph_B = true;
            dzdQ_C_K_W = true;
        end
        function [dzdx_Q_Pw_Ph_B,dzdQ_C_K_W] = getOutputDataTypeImpl(obj)
            dzdx_Q_Pw_Ph_B = propagatedInputDataType(obj,1);
            dzdQ_C_K_W = propagatedInputDataType(obj,1);
        end
        function [dzdx_Q_Pw_Ph_B,dzdQ_C_K_W] = getOutputSizeImpl(obj)
            dzdx_Q_Pw_Ph_B = propagatedInputSize(obj,2);
            dzdQ_C_K_W = propagatedInputSize(obj,3);
        end
        function [dzdx_Q_Pw_Ph_B,dzdQ_C_K_W] = isOutputComplexImpl(obj)
            dzdx_Q_Pw_Ph_B = false;
            dzdQ_C_K_W = false;
        end        

        function [dzdx_Q_Pw_Ph_B,dzdQ_C_K_W] = stepImpl(obj,U_Q_Pw_Ph_B,A_C_I_B,W_Q_C_K,Sel_PKC_IC,Xp_CK_PB)
            nB = size(A_C_I_B,4);
            nP = size(U_Q_Pw_Ph_B,2)*size(U_Q_Pw_Ph_B,3); 
            nQ = size(W_Q_C_K,1); % can be 1 if W is 3D
            nK = size(W_Q_C_K,3)*size(W_Q_C_K,4);
            nC = size(W_Q_C_K,2);
            assert(size(A_C_I_B,4) == nC,'same input C');
            assert(size(Xp_CK_PB,2) == nC*nK,'same input C and K for Xp_CK_PB');
            
            U_Q_PB = reshape(U_Q_Pw_Ph_B,nQ,nB*nP); 
            
            % work using matrix product in flat space [B P, K C] [K C, Q]
            %   d/dA A W = U W'   [B P, Q] [K C, Q]
            %   d/dW A W = A' U
            %W_Q_C_K = obj.right.xvalue;
            dzdx_CK_PB = reshape(W_Q_C_K,nQ,nK*nC)' * U_Q_PB;
            dzdx_CKP_B  = reshape(dzdx_CK_PB,nP*nK*nC,nB);

            ss = size(A_C_I_B); % for thr intermediate result
            dzdx_Q_Pw_Ph_B = munpatcher(dzdx_CKP_B,Sel_PKC_IC,size(A_C_I_B),prod(ss(1:end-1)));            
            dzdQ_C_K_W = reshape(U_Q_PB*Xp_CK_PB',size(W_Q_C_K));          
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
