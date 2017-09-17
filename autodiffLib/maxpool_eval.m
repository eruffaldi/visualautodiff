classdef maxpool_eval < matlab.System
    % untitled5 Add summary here
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

%         function [y,Xp_BP_KC]= isOutputFixedSizeImpl(obj)
%             y = true;
%             Xp_BP_KC = true;
%         end
%         function [y,Xp_BP_KC] = getOutputDataTypeImpl(obj)
%             y = propagatedInputDataType(obj,1);
%             Xp_BP_KC = propagatedInputDataType(obj,1);
%         end
%         function [y,Xp_BP_KC] = getOutputSizeImpl(obj)
%             % TODO            
%         end
%         function [y,Xp_BP_KC] = isOutputComplexImpl(obj)
%             y = false;
%             Xp_BP_KC = false;
%         end
        
        
        function [y,maxindices_BPC] = stepImpl(obj,X_BIC,Sel_PCK_IC,shape_BPC_K,xshape)
            
            % [nB Ph Pw Fin] => [nB patches, Fh Fw Fin]
            Xp_BPC_K = mpatcher(X_BIC,Sel_PCK_IC,shape_BPC_K);
            % => [nB patches]
            [Y_BPC,Yind_BPC] = max(Xp_BPC_K,[],2);
                            
            y = reshape(Y_BPC,xshape);
            maxindices_BPC = Yind_BPC; % in [nB P, S]
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
