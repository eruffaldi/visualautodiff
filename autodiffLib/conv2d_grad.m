classdef conv2d_grad < matlab.System & matlab.system.mixin.Propagates
    % untitled2 Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties

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
        

        function [dzdx_B_Ph_Pw_Q,dzdW_K_C_Q]= isOutputFixedSizeImpl(obj)
            dzdx_B_Ph_Pw_Q = true;
            dzdW_K_C_Q = true;
        end
        function [dzdx_B_Ph_Pw_Q,dzdW_K_C_Q] = getOutputDataTypeImpl(obj)
            dzdx_B_Ph_Pw_Q = propagatedInputDataType(obj,1);
            dzdW_K_C_Q = propagatedInputDataType(obj,1);
        end
        function [dzdx_B_Ph_Pw_Q,dzdW_K_C_Q] = getOutputSizeImpl(obj)
            dzdx_B_Ph_Pw_Q = propagatedInputSize(obj,2);
            dzdW_K_C_Q = propagatedInputSize(obj,3);
        end
        function [dzdx_B_Ph_Pw_Q,dzdW_K_C_Q] = isOutputComplexImpl(obj)
            dzdx_B_Ph_Pw_Q = false;
            dzdW_K_C_Q = false;
        end        

        function [dzdx_B_Ph_Pw_Q,dzdW_K_C_Q] = stepImpl(obj,U_B_Ph_Pw_Q,A_B_I_C,W_K_C_Q,Sel_PKC_IC,Xp_BP_KC)
            nB = size(A_B_I_C,1);
            nP = size(U_B_Ph_Pw_Q,2)*size(U_B_Ph_Pw_Q,3); 
            nQ = size(W_K_C_Q,4); % can be 1 if W is 3D
            nK = size(W_K_C_Q,1)*size(W_K_C_Q,2);
            nC = size(W_K_C_Q,3);
            assert(size(A_B_I_C,4) == nC,'same input C');
            assert(size(Xp_BP_KC,2) == nC*nK,'same input C and K for Xp_BP_KC');
            
            U_BP_Q = reshape(U_B_Ph_Pw_Q,[],nQ); 
            
            % work using matrix product in flat space [B P, K C] [K C, Q]
            %   d/dA A W = U W'   [B P, Q] [K C, Q]
            %   d/dW A W = A' U
            %W_K_C_Q = obj.right.xvalue;
            dzdx_BP_KC = U_BP_Q * reshape(W_K_C_Q,[],nQ)';
            dzdx_B_PKC  = reshape(dzdx_BP_KC,nB,[]);

            ss = size(A_B_I_C); % for thr intermediate result
            dzdx_B_Ph_Pw_Q = munpatcher(dzdx_B_PKC,Sel_PKC_IC,size(A_B_I_C),prod(ss(2:end)));            
            dzdW_K_C_Q = reshape(Xp_BP_KC' * U_BP_Q,size(W_K_C_Q));          
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
