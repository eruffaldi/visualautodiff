classdef maxpool_eval < matlab.System & matlab.system.mixin.Propagates
    % untitled5 Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties
    strides
ksize
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
            sizeA_B_I_C = propagatedInputSize(obj,1);
            sizeZero_Ph_Pw = propagatedInputSize(obj,3);
            nB = sizeA_B_I_C(1); 
            if length(sizeA_B_I_C) == 3
                nC = 1;
            else
                nC = sizeA_B_I_C(4);
            end
            h_filter = obj.ksize(2);
            w_filter = obj.ksize(3);
            nPh = sizeZero_Ph_Pw(1);
            nPw = sizeZero_Ph_Pw(2);
            nP = nPh*nPw;
            r = [nB nPh nPw nC]; % output BPC
            obj.shape_BPC_K = [prod(r) h_filter*w_filter];               
            obj.yshape = [nB,nPh,nPw,nC];
        end

        function [y,maxindices_BP_C]= isOutputFixedSizeImpl(obj)
            y = true;
            maxindices_BP_C = true;
        end
        function [y,maxindices_BP_C] = getOutputDataTypeImpl(obj)
            y = propagatedInputDataType(obj,1);
            maxindices_BP_C = 'int32';
        end
        function [y,maxindices_BP_C] = getOutputSizeImpl(obj)
            sizeA_B_I_Cx = propagatedInputSize(obj,1);
            sizeA_B_I_C = ones(1,4);
            sizeA_B_I_C(1:length(sizeA_B_I_Cx)) = sizeA_B_I_Cx;
            
            sizeZero_Ph_Pw = propagatedInputSize(obj,3);
            nB = sizeA_B_I_C(1); 
            nC = sizeA_B_I_C(4);
            nPh = sizeZero_Ph_Pw(1);
            nPw = sizeZero_Ph_Pw(2);
            nP = nPh*nPw;
            r = [nB nPh nPw nC]; % output BPC
             h_filter = obj.ksize(2);
            w_filter = obj.ksize(3);
            shape_BPC_K = [prod(r) h_filter*w_filter]; % patches for max: BPC K              
            obj.yshape = [nB,nPh,nPw,nC];
            
            y = obj.yshape;           
            maxindices_BP_C = [shape_BPC_K(1),1];        
        end
        function [y,maxindices_BP_C] = isOutputComplexImpl(obj)
            y = false;
            maxindices_BP_C = false;
        end
        
        
        function [y_B_P_C,maxindices_BPC] = stepImpl(obj,X_B_I_C,Sel_PCK_IC,Zero_Ph_Pw)
            
            % [nB Ph Pw Fin] => [nB patches, Fh Fw Fin]
            Xp_BPC_K = mpatcher(X_B_I_C,Sel_PCK_IC,obj.shape_BPC_K);
            % => [nB patches]
            [Y_BPC,Yind_BPC] = max(Xp_BPC_K,[],2);
                            
            y_B_P_C = reshape(Y_BPC,obj.yshape);
            maxindices_BPC = cast(Yind_BPC,'int32'); % in [nB P, S]
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
