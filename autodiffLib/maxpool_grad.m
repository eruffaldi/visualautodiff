classdef maxpool_grad < matlab.System & matlab.system.mixin.Propagates
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
        shape_BPC_K
        yshape
    end

    methods(Access = protected)
        function setupImpl(obj)
            sizeA_B_I_C = propagatedInputSize(obj,6); % X
            sizeZero_Ph_Pw = propagatedInputSize(obj,5); % Zero
            nB = sizeA_B_I_C(1); 
            if length(sizeA_B_I_C) == 3
                nC = 1;
                sizeA_B_I_C4 = [sizeA_B_I_C,1];
            else
                nC = sizeA_B_I_C(4);
                sizeA_B_I_C4 = [sizeA_B_I_C];
            end
            nPh = sizeZero_Ph_Pw(1);
            nPw = sizeZero_Ph_Pw(2);
            nP = nPh*nPw;
            
            
            r = [nB nPh nPw nC]; % output BPC
             h_filter = obj.ksize(2);
            w_filter = obj.ksize(3);
            obj.shape_BPC_K = [prod(r) h_filter*w_filter]; % patches for max: BPC K              
            obj.yshape = sizeA_B_I_C4;
            
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
        

        function J_BIC = stepImpl(obj,U_B_Ph_Pw_Q,argmaxbase,maxindices_BPC,argmaxbasescale,Zero_Ph_Pw,X_B_I_C,Sel_PCK_IC,Sel_PCK_IC_A)
            Jp_BPC_K = zeros(obj.shape_BPC_K,'like',X_B_I_C); % empty patches            
            ind = argmaxbase + (maxindices_BPC(:)-1)*argmaxbasescale; % winning indices from eval step
            
            %Alternative: dxcol(sub2ind(size(dxcol),1:length(max_idx),max_idx)) = dout(:); 
            
            % ?? => [nB patches]  TODO
            % => [nB patches, Fh Fw Fin] via assignment
            Jp_BPC_K(ind) = U_B_Ph_Pw_Q;  % propagate up to them
            
            % => [nB Ph Pw Fin] via unpatching
            ss = size(X_B_I_C);
            J_BIC = munpatcher(Jp_BPC_K,Sel_PCK_IC,obj.yshape,prod(ss(2:end))); % aggregate contributions
            
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
