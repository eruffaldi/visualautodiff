classdef MeanGradient_sys < matlab.System & matlab.system.mixin.Propagates
    % untitled2 Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties

    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(Nontunable,Access = private)
        isscalar
        szJXv
    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            sX = propagatedInputSize(obj,1); % [m1,...mk]
            sJ = propagatedInputSize(obj,2); % [t,1]
            obj.isscalar = sJ(1) == 1;
            obj.szJXv = [sJ(1),prod(sX)];
        end

        function  [p1] = isOutputFixedSizeImpl(obj)
            p1 = true;         
        end
        
        function [p1] = getOutputDataTypeImpl(obj)
            p1 = propagatedInputDataType(obj,1);
        end

        function [p1] = isOutputComplexImpl(obj)
            p1 = false;
        end
            
        function [sz_1] = getOutputSizeImpl(obj) 
            sJ = propagatedInputSize(obj,2); 
            sX = propagatedInputSize(obj,1); 
            sz_1 =  [sJ(1) prod(sX)]; 
        end
        

        function JX = stepImpl(obj,X,JY)
            if obj.isscalar
                % JY is just a scalar
                JX = ones(obj.szJXv)*(JY/numel(X));
            else
                % JY ~ [t,1]
                % JX ~ [t,prod]
                % JX = JY*K   with K~[1,prod]
                JX = (JY/numel(X))*ones(1,numel(X));
            end
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
