classdef conv2d_eval < matlab.System & matlab.system.mixin.Propagates
    % untitled Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties => UNUSED
    properties(Nontunable)
        stride
        padding
    end

    properties(DiscreteState)
        
    end

    % Pre-computed constants
    properties(Nontunable,Access = private)
        yshape
        Xpshape
        shape_CK_PB 
        wshape % for convertin W
        xshape % for converting X 
    end

    methods(Access = protected)
        
        function [a,b,shape_CK_PB,wshape,xshape] = computeSizes(obj)
            sizeC_I_A_B = propagatedInputSize(obj,1);
            sizeQa_C_K_W = propagatedInputSize(obj,2);
            if length(sizeQa_C_K_W) == 4
                nQ = sizeQa_C_K_W(4);
            else
                nQ = 1;
            end
                
            sizeQ_C_K_W = ones(1,4);
            sizeQ_C_K_W(1:numel(sizeQa_C_K_W)) = sizeQa_C_K_W;
            sizeZero_Pw_Ph = propagatedInputSize(obj,4);
            nPh = sizeZero_Pw_Ph(1);
            nPw = sizeZero_Pw_Ph(2);
            nP = nPh*nPw;
            nB = sizeC_I_A_B(end);
            if length(sizeC_I_A_B) == 3
                sizeC_I_A_B4 = [sizeC_I_A_B,1];
            else
                sizeC_I_A_B4 = sizeC_I_A_B;
            end
            nKh = sizeQa_C_K_W(1);
            nKw = sizeQa_C_K_W(2);
            h_filter = nKh; %obj.ksize(2);
            w_filter = nKw; %obj.ksize(3);
            nK = nKh*nKw;
            
            nC = sizeQa_C_K_W(3);
            assert(nC == sizeC_I_A_B4(1));

            a = [nQ,nPh,nPw,nB];
            b = [nK*nC,nB*nP];   
            r = [nC nPh nPw nB];
            shape_CK_PB = [h_filter*w_filter*nC nB*nPh*nPw]; % patches for max: BPC K
            % KC, Q
            wshape = [nQ,nK*nC];
            % [nB , Ih Iw C]            
            xshape = [sizeC_I_A_B4(1:end-1) nB];
        end
        function setupImpl(obj)
            % TODO: compute yshape Xpshape using padding stride and input
            % size
            [obj.yshape,obj.Xpshape,obj.shape_CK_PB,obj.wshape,obj.xshape] = computeSizes(obj);
          
        end
% 
        function [y_Q_Pw_Ph_B,Xp_CK_PB]= isOutputFixedSizeImpl(obj)
            y_Q_Pw_Ph_B = true;
            Xp_CK_PB = true;
        end
        function [y_Q_Pw_Ph_B,Xp_CK_PB] = getOutputDataTypeImpl(obj)
            y_Q_Pw_Ph_B = propagatedInputDataType(obj,1);
            Xp_CK_PB = propagatedInputDataType(obj,1);
        end
        function [y_Q_Pw_Ph_B,Xp_CK_PB] = getOutputSizeImpl(obj)
            [y_Q_Pw_Ph_B,Xp_CK_PB,~] = computeSizes(obj);
        end
        function [y_Q_Pw_Ph_B,Xp_CK_PB] = isOutputComplexImpl(obj)
            y_Q_Pw_Ph_B = false;
            Xp_CK_PB = false;
        end
        
        function [y_Q_Pw_Ph_B,Xp_CK_PB] = stepImpl(obj,X_C_I_B,W_Q_C_K,Sel_IC_CKP,Zero_Pw_Ph)           
            
            Xp_CK_PB = mpatcher(X_C_I_B,Sel_IC_CKP,obj.shape_CK_PB); % for gradient                        
            y_Q_Pw_Ph_B = reshape(reshape(W_Q_C_K,obj.wshape)*Xp_CK_PB,obj.yshape); % B_Ph_Pw_Q
                       
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
