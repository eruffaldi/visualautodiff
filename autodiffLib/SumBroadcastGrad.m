classdef SumBroadcastGrad < matlab.System & matlab.system.mixin.Propagates 
    
    % untitled4 Add summary here
    %
    % NOTE: When renaming the class name untitled4, the file name
    % and constructor name must be updated to use the class name.
    %
    % This template includes most, but not all, possible properties, attributes,
    % and methods that you can implement for a System object in Simulink.

    % Public, tunable properties
    properties

    end

    % Public, non-tunable properties
    properties(Nontunable)

    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(Access = private)

    end

    methods
        % Constructor
        function obj = SumBroadcast(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj,nargin,varargin{:})
        end
    end

    methods(Access = protected)
        %% Common functions
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
        end

        function [Jl,Jr] = stepImpl(obj,ul,ur,J)
            Jl = J;
            sxl = size(ul);
            w = [prod(sxl(1:end-1)) sxl(end)]; % cache
            Jr = reshape(sum(reshape(J,w),1),size(ur));
        end
        function [p1,p2]= isOutputFixedSizeImpl(obj)
            p1 = true;
            p2 = true;
        end
        function [p1,p2] = getOutputDataTypeImpl(obj)
            p1 = propagatedInputDataType(obj,1);
            p2 = p1;
        end
        function [p1,p2] = getOutputSizeImpl(obj)
            % Example: inherit size from first input port
            p1 = propagatedInputSize(obj,1);
            p2 = propagatedInputSize(obj,2);
        end
        function [p1,p2] = isOutputComplexImpl(obj)
            p1 = false;
            p2 = false;
        end

    end

end
