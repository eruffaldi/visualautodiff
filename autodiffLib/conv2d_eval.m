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
        shape_BP_KC 
        wshape % for convertin W
        xshape % for converting X 
    end

    methods(Access = protected)
        
        function [a,b,shape_BP_KC,wshape,xshape] = computeSizes(obj)
            sizeA_B_I_C = propagatedInputSize(obj,1);
            sizeW_K_C_Qa = propagatedInputSize(obj,2);
            if length(sizeW_K_C_Qa) == 4
                nQ = sizeW_K_C_Qa(4);
            else
                nQ = 1;
            end
                
            sizeW_K_C_Q = ones(1,4);
            sizeW_K_C_Q(1:numel(sizeW_K_C_Qa)) = sizeW_K_C_Qa;
            sizeZero_Ph_Pw = propagatedInputSize(obj,4);
            nPh = sizeZero_Ph_Pw(1);
            nPw = sizeZero_Ph_Pw(2);
            nP = nPh*nPw;
            nB = sizeA_B_I_C(1);
            if length(sizeA_B_I_C) == 3
                sizeA_B_I_C4 = [sizeA_B_I_C,1];
            else
                sizeA_B_I_C4 = sizeA_B_I_C;
            end
            nKh = sizeW_K_C_Qa(1);
            nKw = sizeW_K_C_Qa(2);
            h_filter = nKh; %obj.ksize(2);
            w_filter = nKw; %obj.ksize(3);
            nK = nKh*nKw;
            
            nC = sizeW_K_C_Qa(3);
            assert(nC == sizeA_B_I_C4(end));

            a = [nB,nPh,nPw,nQ];
            b = [nB*nP,nK*nC];   
            r = [nB nPh nPw nC]; % output BPC
            shape_BP_KC = [nB*nPh*nPw h_filter*w_filter*nC]; % patches for max: BPC K
            % KC, Q
            wshape = [nK*nC,nQ];
            % [nB , Ih Iw C]            
            xshape = [nB, sizeA_B_I_C4(2:end)];
        end
        function setupImpl(obj)
            % TODO: compute yshape Xpshape using padding stride and input
            % size
            [obj.yshape,obj.Xpshape,obj.shape_BP_KC,obj.wshape,obj.xshape] = computeSizes(obj);
          
        end
% 
        function [y_B_Ph_Pw_Q,Xp_BP_KC]= isOutputFixedSizeImpl(obj)
            y_B_Ph_Pw_Q = true;
            Xp_BP_KC = true;
        end
        function [y_B_Ph_Pw_Q,Xp_BP_KC] = getOutputDataTypeImpl(obj)
            y_B_Ph_Pw_Q = propagatedInputDataType(obj,1);
            Xp_BP_KC = propagatedInputDataType(obj,1);
        end
        function [y_B_Ph_Pw_Q,Xp_BP_KC] = getOutputSizeImpl(obj)
            [y_B_Ph_Pw_Q,Xp_BP_KC,~] = computeSizes(obj);
        end
        function [y_B_Ph_Pw_Q,Xp_BP_KC] = isOutputComplexImpl(obj)
            y_B_Ph_Pw_Q = false;
            Xp_BP_KC = false;
        end
        
        function [y_B_Ph_Pw_Q,Xp_BP_KC] = stepImpl(obj,X_B_I_C,W_K_C_Q,Sel_PKC_IC,Zero_Ph_PW)           
            
            %Xp_BP_KC = mpatcher(A_B_I_C,Sel_PKC_IC,obj.shape_BP_KC); % for gradient                        
            w = gathermatrixmat(Sel_PKC_IC,reshape(X_B_I_C,obj.xshape),length(Sel_PKC_IC));
            Xp_BP_KC = reshape(w,obj.shape_BP_KC); % [nB , P, F, C]


            y_B_Ph_Pw_Q = reshape(Xp_BP_KC*reshape(W_K_C_Q,obj.wshape),obj.yshape); % B_Ph_Pw_Q
                       
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
