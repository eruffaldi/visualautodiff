classdef AtJ_sys < matlab.System & matlab.system.mixin.Propagates
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
        szJBv
        szJ
        n
    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            % vec J ~ [t,mn] --> [m,n] if t=1
            % vec A ~ [m,q]  --> JB ~ [t,nq]
            sJ = propagatedInputSize(obj,1); 
            sA = propagatedInputSize(obj,2); 
            m = sA(1);
            q = sA(2);
            n = sJ(2)/q;
            obj.n = n;
            obj.isscalar = sJ(1) == 1;
            obj.szJBv = [sJ(1),n*q];
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
            
        function [sz_1] = getOutputSizeImpl(obj) 
            sJ = propagatedInputSize(obj,1); 
            sA = propagatedInputSize(obj,2); 
            q = sA(2);
            n = sJ(2)/q;
            sz_1 =  [sJ(1) n*q]; 
        end
        

        function y = stepImpl(obj,J,A)
            if obj.isscalar
                y = reshape(A'*reshape(J, obj.szJ),obj.szJBv);
            else
                y = J*kron(eye(obj.n),A);
            end
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
