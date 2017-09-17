classdef conv2d_grad < matlab.System
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
        

%         function [dzdx,dzdW]= isOutputFixedSizeImpl(obj)
%             dzdx = true;
%             dzdW = true;
%         end
%         function [dzdx,dzdW] = getOutputDataTypeImpl(obj)
%             dzdx = propagatedInputDataType(obj,1);
%             dzdW = propagatedInputDataType(obj,1);
%         end
%         function [y,Xp_BP_KC] = getOutputSizeImpl(obj)
%             % TODO            
%         end
%         function [dzdx,dzdW] = isOutputComplexImpl(obj)
%             dzdx = false;
%             dzdW = false;
%         end        

        function [dzdx,dzdW] = stepImpl(obj,U_B_Ph_Pw_Q,W_K_C_Q,Sel_PKC_IC,xshape,Xp_BP_KC)
            nB = size(U_B_Ph_Pw_Q,1);
            nP = xshape(2)*xshape(3);
            nQ = size(U_B_Ph_Pw_Q,4);
            U_BP_Q = reshape(U_B_Ph_Pw_Q,nB*nP,nQ); % B_Ph_Pw_Q => BP_Q
            
            % work using matrix product in flat space [B P, K C] [K C, Q]
            %   d/dA A W = U W'   [B P, Q] [K C, Q]
            %   d/dW A W = A' U
            %W_K_C_Q = obj.right.xvalue;
            dzdx_BP_KC = U_BP_Q * reshape(W_K_C_Q,[],nQ)';
            dzdx_B_PKC  = reshape(dzdx_BP_KC,nB*nP,[]);
            dzdx = munpatcher(dzdx_B_PKC,Sel_PKC_IC,size(U_B_Ph_Pw_Q));

            
            dzdW = reshape(Xp_BP_KC' * U_BP_Q,size(W_K_C_Q));          
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
