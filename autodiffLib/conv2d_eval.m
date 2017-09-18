classdef conv2d_eval < matlab.System
    % untitled Add summary here
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
% 
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
%         
        function [y,Xp_BP_KC] = stepImpl(obj,A_B_I_C,W_K_C_Q,shape_BP_KC,xshape,Sel_PKC_IC)
            Xp_BP_KC = mpatcher(A_B_I_C,Sel_PKC_IC,shape_BP_KC); % for gradient
            
            nQ = xshape(4);                                    
            
            y = reshape(Xp_BP_KC*reshape(W_K_C_Q,[],nQ),xshape); % B_Ph_Pw_Q
                        
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
