classdef softmax_cross_entropy_with_logitsGradSystem < matlab.System & matlab.system.mixin.Propagates 
    
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
        function obj = softmax_cross_entropy_with_logitsGradSystem(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj,nargin,varargin{:})
        end
    end

    methods(Access = protected)
        %% Common functions
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
        end

        function [J] = stepImpl(obj,logits,labels,Jin,logitsoffsetted,sumx)
            % output = batch x 1
            % logits = batch x C
            classes = size(logits,2);
            a = (exp(logitsoffsetted) ./ repmat(sumx,1,classes)); % batch x 1 WHY?
            Jo = a-labels; % batch x C
            J = repmat(Jin,1,classes).*Jo; 

        end
        function [p1]= isOutputFixedSizeImpl(obj)
            p1 = true;
        end
        function [p1] = getOutputDataTypeImpl(obj)
            p1 = propagatedInputDataType(obj,1);
        end
        function [p1] = getOutputSizeImpl(obj)
            % Example: inherit size from first input port
            p1 = propagatedInputSize(obj,1);
        end
        function [p1] = isOutputComplexImpl(obj)
            p1 = false;
        end

    end

end
