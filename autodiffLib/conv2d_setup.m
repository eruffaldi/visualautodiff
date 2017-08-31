classdef conv2d_setup < matlab.System
    % conv2d_setup
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
            nQ = xr(4);
            
            % Fh Fw Fi Fo
            h_filter = xr(1);
            w_filter = xr(2);
            padding = obj.padding;
            stride = obj.stride(1);
            if obj.padding == -1
                % automatic padding to satisfy requirement
                paddingh = (h_filter-1)/2;
                paddingw = (w_filter-1)/2;
            else
                % can break
                paddingh = padding;
                paddingw = padding;
            end
            [~,shape_BPKC,obj.shapeP] = mpatchprepare(xl,[h_filter w_filter],[stride stride],[paddingh,paddingw], 'BPKC'); % N independent
            
            obj.shape_BP_KC = [prod(shape_BPKC(1:2)), prod(shape_BPKC(3:5))];
            obj.xshape = [xl(1) obj.shapeP(1) obj.shapeP(2) nQ];
                       
        end

        function [kq,sz] = stepImpl(obj,X,W)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            y = u;
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
