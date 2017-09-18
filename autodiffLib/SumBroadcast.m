classdef SumBroadcast < matlab.System & matlab.system.mixin.Propagates 
    
    % SumBroadcast

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

        function y = stepImpl(obj,ul,ur)
            sl = size(ul); % A1,...,An e.g. 100x10
            w = [prod(sl(1:end-1)) sl(end)]; % A1...An-1,An. 100x10
            % sr = An,1 or 1,An
            y = reshape(reshape(ul,w) + repmat(ur(:)',w(1),1),sl);
        end
        function [p1]= isOutputFixedSizeImpl(obj)
            p1 = true;
        end
        function [p1] = getOutputDataTypeImpl(obj)
            p1 = propagatedInputDataType(obj,1);
        end
        function out = getOutputSizeImpl(obj)
            out = propagatedInputSize(obj,1);
        end
        function [p1] = isOutputComplexImpl(obj)
            p1 = false;
        end

    end

end
