classdef softmax_cross_entropy_with_logitsSystem < matlab.System & matlab.system.mixin.Propagates 
    
    % softmax_cross_entropy_with_logitsSystem

    % Public, tunable properties
    properties

    end

    % Public, non-tunable properties
    properties(Nontunable)
        classdim;
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
            obj.classdim = 1;
            setProperties(obj,nargin,varargin{:})
        end
    end

    methods(Access = protected)
        %% Common functions
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
        end

        function [loss,logitsoffsetted,sumx] = stepImpl(obj,xlogits,xlabels)
            classdim = obj.classdim;
            nclasses = size(xlogits,classdim);
            
            
            logitsmax = max(xlogits,[],classdim); % along class
            if obj.classdim == 2
                logitsoffsetted = xlogits - repmat(logitsmax,1,nclasses); % broadcast class
            else
                logitsoffsetted = xlogits - repmat(logitsmax,nclasses,1); % broadcast class
            end
            sumx = sum(exp(logitsoffsetted),classdim); % exp and sum along class
            if obj.classdim == 2
                bscratch = repmat(log(sumx),1,nclasses);
            else
                bscratch = repmat(log(sumx),nclasses,1);
            end
            
            loss = sum(xlabels .* (bscratch - logitsoffsetted),classdim);             
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
            ins = propagatedInputSize(obj,1); % Class Batch
            % outputs: loss,logitsoffsetted,sumx
            p1 = [1,ins(2)]; % 1 
            p2 = ins;
            p3 = [1,ins(2)]; % 1 x C
        end
        function [p1,p2,p3] = isOutputComplexImpl(obj)
            p1 = false;
            p2 = false;
            p3 = false;
        end

    end

end
