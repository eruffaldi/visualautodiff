classdef conv2d_setup < matlab.System
    % conv2d_setup
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties
        padding = -1;
        stride = [1,1,1,1]
    end

    properties(DiscreteState)
    
    end

    % Pre-computed constants
    properties(Access = private)
        xshape
        shape_BP_KC
        Sel_PKC_IC
    end

    methods(Access = protected)
        function setupImpl(obj)
            xr = propagatedInputSize(obj,1);
            xl = propagatedInputSize(obj,2);
            
            if length(xr) == 3
                nQ = 1;
            else
                nQ = xr(4);
            end
            
            % Fh Fw Fi Fo
            h_filter = xr(1);
            w_filter = xr(2);
            padding = obj.padding;
            stride = obj.stride(1);
            if padding == -1
                % automatic padding to satisfy requirement
                paddingh = (h_filter-1)/2;
                paddingw = (w_filter-1)/2;
            else
                % can break
                paddingh = padding;
                paddingw = padding;
            end
            [obj.Sel_PKC_IC,shape_BPKC,shapeP] = mpatchprepare(xl,[h_filter w_filter],[stride stride],[paddingh,paddingw], 'BPKC'); % N independent
            
            obj.shape_BP_KC = [prod(shape_BPKC(1:2)), prod(shape_BPKC(3:5))];
            obj.xshape = [xl(1) shapeP(1) shapeP(2) nQ];                      
        end
                
%         function  [p1] = isOutputFixedSizeImpl(obj)
%             p1 = true;         
%         end
%         
%         function [p1] = getOutputDataTypeImpl(obj)
%             p1 = propagatedInputType(obj,1);
%         end
% 
%         function [p1] = isOutputComplexImpl(obj)
%             p1 = false;
%         end
% 
%         % outputs mask and y are same size
%         function [Sel_PKC_IC,xshape,shape_BP_KC] = getOutputSizeImpl(obj) 
%             Sel_PKC_IC = size(obj.Sel_PKC_IC);
%             xshape = size(obj.xshape);
%             shape_BP_KC = size(obj.shape_BP_KC);
%         end

        function [Sel_PKC_IC,xshape,shape_BP_KC] = stepImpl(obj,X,W)
            Sel_PKC_IC = obj.Sel_PKC_IC;
            xshape = obj.xshape;
            shape_BP_KC = obj.shape_BP_KC;            
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
