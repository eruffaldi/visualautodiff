classdef conv2d_eval < matlab.System & matlab.system.mixin.Propagates
    % untitled Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties
        padding
stride
    end

    properties(DiscreteState)
        
    end

    % Pre-computed constants
    properties(Access = private)
        yshape
        Xpshape
    end

    methods(Access = protected)

        function [a,b] = computeSizes(obj)
            sizeA_B_I_C = propagatedInputSize(obj,1);
            sizeW_K_C_Q = propagatedInputSize(obj,2);
            sizeZero_Ph_Pw = propagatedInputSize(obj,4);
            nPh = sizeZero_Ph_Pw(1);
            nPw = sizeZero_Ph_Pw(2);
            nP = nPh*nPw;
            nB = sizeA_B_I_C(1);
            nK = sizeW_K_C_Q(1);
            nC = sizeW_K_C_Q(2);
            nQ = sizeW_K_C_Q(4);

            a = [nB,nPh,nPw,nQ];
            b = [nB*nP,nK*nC];               
        end
        function setupImpl(obj)
            % TODO: compute yshape Xpshape using padding stride and input
            % size
            [obj.yshape,obj.Xpshape] = computeSizes(obj);

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
            [y_B_Ph_Pw_Q,Xp_BP_KC] = computeSizes(obj);
        end
        function [y_B_Ph_Pw_Q,Xp_BP_KC] = isOutputComplexImpl(obj)
            y_B_Ph_Pw_Q = false;
            Xp_BP_KC = false;
        end
        
        function [y_B_Ph_Pw_Q,Xp_BP_KC] = stepImpl(obj,A_B_I_C,W_K_C_Q,Sel_PKC_IC,Zero_Ph_PW)           
            
            Xp_BP_KC = mpatcher(A_B_I_C,Sel_PKC_IC,obj.Xpshape); % for gradient                        
            y_B_Ph_Pw_Q = reshape(Xp_BP_KC*reshape(W_K_C_Q,[],obj.yshape(4)),obj.yshape); % B_Ph_Pw_Q
                       
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
