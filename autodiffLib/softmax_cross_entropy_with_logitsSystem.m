classdef softmax_cross_entropy_with_logitsSystem < matlab.System & matlab.system.mixin.Propagates 
    
    % softmax_cross_entropy_with_logitsSystem

    % Public, tunable properties
    properties

    end

    % Public, non-tunable properties
    properties(Nontunable)

    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(Nontunable,Access = private)

    end

    methods
        % Constructor
        function obj = softmax_cross_entropy_with_logitsSystem(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj,nargin,varargin{:})
        end
    end

    methods(Access = protected)
        %% Common functions
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
        end

        function [loss,logitsoffsetted,sumx] = stepImpl(obj,xlogits,xlabels)
           classes = size(xlogits,2);
            classdim = 2;
            
            
            logitsmax = max(xlogits,[],classdim); % along class
            logitsoffsetted = xlogits - repmat(logitsmax,1,classes); % broadcast class
            sumx = sum(exp(logitsoffsetted),classdim); % exp and sum along class
            ww = log(sumx);
            if sum(isnan(ww)) > 0
                error('nan');
            end
            loss = sum((xlabels .* (repmat(ww,1,classes) - logitsoffsetted)),classdim); 
            
        end
        function [p1,p2,p3]= isOutputFixedSizeImpl(obj)
            p1 = true;
            p2 = true;
            p3 = true;
        end
        function [p1,p2,p3] = getOutputDataTypeImpl(obj)
            p1 = propagatedInputDataType(obj,1);
            p2 = propagatedInputDataType(obj,1);
            p3 = propagatedInputDataType(obj,1);
        end
        function [p1,p2,p3] = getOutputSizeImpl(obj)
            % Example: inherit size from first input port
            ins = propagatedInputSize(obj,1); % B C
            p1 = [ins(1),1]; % 1 x C
            p2 = ins;
            p3 = [ins(1),1]; % 1 x C
        end
        function [p1,p2,p3] = isOutputComplexImpl(obj)
            p1 = false;
            p2 = false;
            p3 = false;
        end

    end

end
