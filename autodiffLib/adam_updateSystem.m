classdef adam_updateSystem < matlab.System & matlab.system.mixin.Propagates 
    
    % AdamUpdateSystem

    % Public, tunable properties
    properties

    end

    % Public, non-tunable properties
    properties(Nontunable)

    end

    properties(DiscreteState)
        m_t
        s_t
    end

    % Pre-computed constants
    properties(Access = private)

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
        
         function resetImpl(obj)
            obj.m_t = zeros(propagatedInputSize(obj,5));
            obj.s_t = obj.m_t;
         end
        
         function [sz,dt,cp] = getDiscreteStateSpecificationImpl(obj,name)
             sz = propagatedInputSize(obj,5);
             dt = 'double';
             cp = false;
         end

        function [y] = stepImpl(obj,lrt,epsilon,beta1,beta2,g)
                obj.m_t = beta1*obj.m_t+ (1-beta1)*g;
                obj.s_t = beta2*obj.s_t+ (1-beta2)*g.*g;            
              y =lrt * obj.m_t ./ (sqrt(obj.s_t) + epsilon);
        end
        function [p1]= isOutputFixedSizeImpl(obj)
            p1 = true;
        end
        function [p1] = getOutputDataTypeImpl(obj)
            p1 = propagatedInputDataType(obj,1);
        end
        function [p1] = getOutputSizeImpl(obj)
            % Example: inherit size from first input port
            ins = propagatedInputSize(obj,5); % B C
            p1 = ins;
        end
        function [p1] = isOutputComplexImpl(obj)
            p1 = false;
        end

    end

end
