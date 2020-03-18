classdef JBt_sys < matlab.System & matlab.system.mixin.Propagates
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
    properties(Nontunable, Access = private)
        isscalar
        szJAv
        szJ
        m
    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            % flattened vec J~[t, mn]
            % J~[m,n] B~[q,n] -> JA~[m,q]
            sJ = propagatedInputSize(obj,1); 
            sB = propagatedInputSize(obj,2); 
            m = sJ(2)/sB(2);
            n = sB(2);
            q = sB(1);
            obj.m = m;
            obj.isscalar = sJ(1) == 1;
            obj.szJAv = [sJ(1),m*q];
            obj.szJ = [m,n];
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
            
        function [szJAv] = getOutputSizeImpl(obj) 
            sJ = propagatedInputSize(obj,1); 
            sB = propagatedInputSize(obj,2); 
            m = sJ(2)/sB(2);
            q = sB(1);
            szJAv = [sJ(1), m*q];
        end
        

        function y = stepImpl(obj,J,B)
            if obj.isscalar
                y = reshape(reshape(J, obj.szJ)*B',obj.szJAv);
            else
                y =  J*kron(B',eye(obj.m));
            end
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
