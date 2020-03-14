classdef scalar_assign_J < matlab.System & matlab.system.mixin.Propagates
    % untitled2 Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties(Nontunable)

    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(Access = private)

    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
        end

        function [Jx,Jyo] = stepImpl(obj,J,index)
            Jx = zeros(size(J,1),1);
            Jx(index) = J(index,index);
            Jyo = J;
            Jyo(index,index) = 0;
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
        
        function  [p1,p2] = isOutputFixedSizeImpl(obj)
            p1 = true;
            p2 = true;
         
        end
        
        function [p1,p2] = getOutputDataTypeImpl(obj)
            p1 = 'double'; % propagatedInputDataType(obj,1);
            p2 = 'double';
        end

        function [p1,p2] = isOutputComplexImpl(obj)
            p1 = false;
            p2 = false;
        end

        % size(Jx) = [size(Jy,1),1]
        function [sz_Jx,sz_Jyo] = getOutputSizeImpl(obj) 
            sz_Jx =  propagatedInputSize(obj,1);
            sz_Jyo = sz_Jx;
            sz_Jx(2) = 1;
        end
                
    end
end
