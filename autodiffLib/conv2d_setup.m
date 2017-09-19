classdef conv2d_setup < matlab.System &     matlab.system.mixin.Propagates
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
        Zero_Ph_Pw
    end

    methods(Access = protected)
        function [w,shape_BPKC,shapeP] = computeSomething(obj)
            xra = propagatedInputSize(obj,2); % X
            xla = propagatedInputSize(obj,1); % W
            
            if length(xra) == 3
                xr = [xra(:)' , 1];
            else
                xr = xra;
            end
            
            if length(xla) == 3
                xl = [xla(:)' , 1];
            else
                xl = xla;
            end

            % Fh Fw Fi Fo
            h_filter = xr(1);
            w_filter = xr(2);
            padding = obj.padding;
            stride = obj.stride(1);
            if padding == -1
                % automatic padding to satisfy requirement
                paddingh = ceil((h_filter-1)/2);
                paddingw = ceil((w_filter-1)/2);
            else
                % can break
                paddingh = padding;
                paddingw = padding;
            end
            [w,shape_BPKC,shapeP] = mpatchprepare(xl,[h_filter w_filter],[stride stride],[paddingh,paddingw], 'BPKC'); % N independent
        end

        function setupImpl(obj)
            xr = propagatedInputSize(obj,1);
            xl = propagatedInputSize(obj,2);
            
            if length(xr) == 3
                nQ = 1;
            else
                nQ = xr(4);
            end

            [w,shape_BPKC,shapeP] = obj.computeSomething();
            obj.Sel_PKC_IC = w.pickidx;
            obj.shape_BP_KC = int32([prod(shape_BPKC(1:2)), prod(shape_BPKC(3:5))]);
            obj.xshape = int32([xl(1) shapeP(1) shapeP(2) nQ]);
            obj.Zero_Ph_Pw = zeros(shapeP','logical'); % fake
        end
                
        function  [p1,p2] = isOutputFixedSizeImpl(obj)
            p1 = true; 
            p2 = true;
        end
        
        function [p1,p2] = getOutputDataTypeImpl(obj)
            p1 = 'int32';
            p2 = 'logical';
        end

        function [p1,p2] = isOutputComplexImpl(obj)
            p1 = false;
p2 = false;
        end

        % outputs mask and y are same size
        function [Sel_PKC_IC,Zero_Ph_Pw] = getOutputSizeImpl(obj) 
            

            [w,shape_BPKC,shapeP] = obj.computeSomething();
            Sel_PKC_IC = size(w.pickidx); % decided only after SETUP
            Zero_Ph_Pw = shapeP;
        end

        function [Sel_PKC_IC,Zero_Ph_Pw] = stepImpl(obj,X,W)
            Sel_PKC_IC = obj.Sel_PKC_IC;
            Zero_Ph_Pw = obj.Zero_Ph_Pw;
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
