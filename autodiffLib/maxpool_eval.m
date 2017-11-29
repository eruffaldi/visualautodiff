classdef maxpool_eval < matlab.System & matlab.system.mixin.Propagates
    % untitled5 Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties(Nontunable)
    strides
ksize
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
            sizeA_C_I_B = propagatedInputSize(obj,1);
            sizeZero_Ph_Pw = propagatedInputSize(obj,3);
            nB = sizeA_C_I_B(end); 
            if length(sizeA_C_I_B) == 3
                nC = 1;
            else
                nC = sizeA_C_I_B(1);
            end
            h_filter = obj.ksize(2);
            w_filter = obj.ksize(3);
            nPh = sizeZero_Ph_Pw(1);
            nPw = sizeZero_Ph_Pw(2);
            nP = nPh*nPw;
            r = [nC nPh nPw nB]; % output BPC
            obj.shape_K_CPB = [h_filter*w_filter prod(r)];               
            obj.yshape = [nC,nPh,nPw,nB];
        end

        function [y,maxindices_C_PB]= isOutputFixedSizeImpl(obj)
            y = true;
            maxindices_C_PB = true;
        end
        function [y,maxindices_C_PB] = getOutputDataTypeImpl(obj)
            y = propagatedInputDataType(obj,1);
            maxindices_C_PB = 'int32';
        end
        function [y,maxindices_C_PB] = getOutputSizeImpl(obj)
            sizeA_Cx_I_B = propagatedInputSize(obj,1);
            sizeA_C_I_B = ones(1,4);
            sizeA_C_I_B(1:length(sizeA_Cx_I_B)) = sizeA_Cx_I_B;
            
            sizeZero_Ph_Pw = propagatedInputSize(obj,3);
            nB = sizeA_C_I_B(4); 
            nC = sizeA_C_I_B(1);
            nPh = sizeZero_Ph_Pw(1);
            nPw = sizeZero_Ph_Pw(2);
            nP = nPh*nPw;
            r = [nC nPh nPw nB]; % output BPC
             h_filter = obj.ksize(2);
            w_filter = obj.ksize(3);
            shape_K_CPB = [ h_filter*w_filter prod(r)]; % patches for max: BPC K              
            obj.yshape = [nC,nPh,nPw,nB];
            
            y = obj.yshape;           
            maxindices_C_PB = [1,shape_K_CPB(2)];        
        end
        function [y,maxindices_C_PB] = isOutputComplexImpl(obj)
            y = false;
            maxindices_C_PB = false;
        end
        
        
        function [y_C_P_B,maxindices_CPB] = stepImpl(obj,X_C_I_B,Sel_IC_KCP,Zero_Ph_Pw)
            
            % [nB Ph Pw Fin] => [nB patches, Fh Fw Fin]
            Xp_K_CPB = mpatcher(X_C_I_B,Sel_IC_KCP,obj.shape_K_CPB,1);
            % => [nB patches]
            [Y_CPB,Yind_CPB] = max(Xp_K_CPB,[],1);
                            
            y_C_P_B = reshape(Y_CPB,obj.yshape);
            maxindices_CPB = cast(Yind_CPB,'int32'); % in [nB P, S]
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
