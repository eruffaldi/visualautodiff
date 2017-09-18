classdef maxpool_grad < matlab.System
    % untitled6 Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties
    ksize
strides
    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(Access = private)
        
    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
% TODO: obj.shape_BPC_K
        end
%         
% 
% 
         function [dzdx]= isOutputFixedSizeImpl(obj)
            dzdx = true;          
        end
        function [dzdx] = getOutputDataTypeImpl(obj)
            dzdx = propagatedInputDataType(obj,1);
          
        end
        function [y] = getOutputSizeImpl(obj)
                    y = propagatedInputSize(obj,6); % == X_B_I_C
        end
        function [dzdx] = isOutputComplexImpl(obj)
                dzdx = false;
        end        
        

        function J_B_I_C = stepImpl(obj,up_B_P_C,argmaxbase,maxindices_BPC,argmaxbasescale,Zero_Ph_Pw,X_B_I_C)
            nB = size(U_B_Ph_Pw_Q,1);
            nP = size(U_B_Ph_Pw_Q,2)*size(U_B_Ph_Pw_Q,3);
            nC = size(U_B_Ph_Pw_Q,4);

            shape_BPC_K =[nB,nP,nC];
            Jp_BPC_K = mzeros(shape_BPC_K,propagatedInputDataType(obj,1)); % empty patches            
            ind = argmaxbase + (maxindices_BPC(:)-1)*argmaxbasescale; % winning indices from eval step
            
            %Alternative: dxcol(sub2ind(size(dxcol),1:length(max_idx),max_idx)) = dout(:); 
            
            % ?? => [nB patches]  TODO
            % => [nB patches, Fh Fw Fin] via assignment
            Jp_BPC_K(ind) = up_B_P_C;  % propagate up to them
            
            % => [nB Ph Pw Fin] via unpatching
            J_B_I_C = munpatcher(Jp_BPC_K,Sel_PCK_IC,size(X_B_I_C)); % aggregate contributions
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
