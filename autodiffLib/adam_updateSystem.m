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
    properties(Nontunable,Access = private)
        m_tsize
        m_ttype
    end

    methods
       
    end

    methods(Access = protected)
        %% Common functions
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            obj.m_tsize = propagatedInputSize(obj,6);
            obj.m_ttype = 'single'; % %propagatedInputDataType(obj,6);
            obj.m_t = zeros(obj.m_tsize,obj.m_ttype);
            obj.s_t = obj.m_t;
        end
        
         function resetImpl(obj)
            % zeros(propagatedInputSize(obj,5),propagatedInputDataType(obj,5));
         end
         
         function [sz,dt,cp] = getDiscreteStateSpecificationImpl(obj,name)
             sz = propagatedInputSize(obj,6);
             dt = 'single'; %propagatedInputDataType(obj,6);
             cp = false;
         end

        function [effective_gradient] = stepImpl(obj,learning_rate,epsilon,beta1,beta2,gradient,initial_for_size)
                obj.m_t = beta1*obj.m_t+ (1-beta1)*gradient;
                obj.s_t = beta2*obj.s_t+ (1-beta2)*gradient.*gradient;            
                k = (sqrt(obj.s_t) + epsilon);
                if sum(k == 0) > 0 | sum(obj.s_t < 0) > 0
                    error('bad');
                end
                effective_gradient  =learning_rate * obj.m_t ./ (sqrt(obj.s_t) + epsilon);
        end
        function [p1]= isOutputFixedSizeImpl(obj)
            p1 = true;
        end
        function [p1] = getOutputDataTypeImpl(obj)
            p1 = propagatedInputDataType(obj,6);
        end
        function [p1] = getOutputSizeImpl(obj)
            % Example: inherit size from first input port
            p1 = propagatedInputSize(obj,6);
        end
        function [p1] = isOutputComplexImpl(obj)
            p1 = false;
        end

    end

end
