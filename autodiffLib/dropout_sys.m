classdef dropout_sys < matlab.System
    % dropout_sys Add summary here
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

        function [y,mask] = stepImpl(obj,x,rate)
            q = (rand(size(x), 'single') >= rate);
            realrate = sum(q(:) == false)/numel(q);
            scale = single(1 / (1 - realrate));
            mask = scale * q;
            y = mask .* x;
        end
        
        function  [p1] = isOutputFixedSizeImpl(obj)
            p1 = true;
         
        end
        
        function [p1] = getOutputDataTypeImpl(obj)
            p1 = propagatedInputType(obj,1);
        end

        function [p1] = isOutputComplexImpl(obj)
            p1 = false;
        end

        % outputs mask and y are same size
        function [sz_y,sz_mask] = getOutputSizeImpl(obj) 
            sz_y =  propagatedInputSize(obj,1); 
            sz_mask = sz_y;
        end
        

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
