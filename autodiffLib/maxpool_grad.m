classdef maxpool_grad < matlab.System
    % untitled6 Add summary here
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
% 
% 
% %         function [dzdx,dzdW]= isOutputFixedSizeImpl(obj)
%             dzdx = true;
%             dzdW = true;
%         end
%         function [dzdx,dzdW] = getOutputDataTypeImpl(obj)
%             dzdx = propagatedInputDataType(obj,1);
%             dzdW = propagatedInputDataType(obj,1);
%         end
%         function [y,Xp_BP_KC] = getOutputSizeImpl(obj)
%             % TODO            
%         end
%         function [dzdx,dzdW] = isOutputComplexImpl(obj)
%             dzdx = false;
%             dzdW = false;
%         end        
        

        function J_BIC = stepImpl(obj,up_BPC,shape_BPC_K,argmaxbase,maxindices_BPC,argmaxbasescale)
            Jp_BPC_K = mzeros(shape_BPC_K,propagatedInputDataType(obj,1)); % empty patches            
            ind = argmaxbase + (maxindices_BPC(:)-1)*argmaxbasescale; % winning indices from eval step
            
            %Alternative: dxcol(sub2ind(size(dxcol),1:length(max_idx),max_idx)) = dout(:); 
            
            % ?? => [nB patches]  TODO
            % => [nB patches, Fh Fw Fin] via assignment
            Jp_BPC_K(ind) = up_BPC;  % propagate up to them
            
            % => [nB Ph Pw Fin] via unpatching
            J_BIC = munpatcher(Jp_BPC_K,Sel_PCK_IC,size(up_BPC)); % aggregate contributions
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
