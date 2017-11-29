classdef maxpool_grad < matlab.System & matlab.system.mixin.Propagates
    % maxpool_grad Gradient of the Max Pool

    % Public, tunable properties
    properties(Nontunable)
        ksize     % kernel size aka scaling e.g. 1,2,2,1
        strides   % strides
    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(Nontunable,Access = private)
        shape_K_CPB
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
            obj.shape_K_CPB = [prod(r) h_filter*w_filter]; % patches for max: BPC K              
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
                    y = propagatedInputSize(obj,6); % == X_C_I_B
        end
        function [dzdx] = isOutputComplexImpl(obj)
                dzdx = false;
        end        
        

        function J_CIB = stepImpl(obj,U_B_Ph_Pw_Q,argmaxbase,maxindices_BPC,argmaxbasescale,Zero_Ph_Pw,X_C_I_B,Sel_PCK_IC,Sel_PCK_IC_A)
            Jp_K_CPB = zeros(obj.shape_K_CPB,'like',X_C_I_B); % empty patches            
            ind = argmaxbase + (maxindices_BPC(:)-1)*argmaxbasescale; % winning indices from eval step
            
            %Alternative: dxcol(sub2ind(size(dxcol),1:length(max_idx),max_idx)) = dout(:); 
            
            % ?? => [nB patches]  TODO
            % => [nB patches, Fh Fw Fin] via assignment
            Jp_K_CPB(ind) = U_B_Ph_Pw_Q;  % propagate up to them
            
            % => [nB Ph Pw Fin] via unpatching
            ss = size(X_C_I_B);
            J_CIB = munpatcher(Jp_K_CPB,Sel_PCK_IC,obj.yshape,prod(ss(1:end-1)),1); % aggregate contributions
            
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
