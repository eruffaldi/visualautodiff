classdef infoOpaque < matlab.System &  matlab.system.mixin.Propagates
    % untitled Add summary here
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

        function [mt,s] = stepImpl(obj,u)
            t = propagatedInputDataType(obj,1);
            [~,s,mt] = decodeOpaqueTypeName(t);
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
        

        function [out1,out2] = getOutputSizeImpl(obj)
            out1 = 1; % single value
            
            t = propagatedInputDataType(obj,1);
            s = propagatedInputSize(obj,1);
            disp([gcb '/getOutputSizeImpl'])
            if isempty(t)
                disp('*no t');
                out2 = 1;
                return;
            end
            if isempty(s)
                disp('*no s');
                out2 = 1;
                return;
            end
            disp(t)
            disp(s)
            
            [~,sizes] = decodeOpaqueTypeName(t);
            out2 = length(sizes);
        end
     function [out1,out2] = isOutputFixedSizeImpl(obj)
                out1 = true;
                out2 = true;
        end

        function [out1,out2] = isOutputComplexImpl(obj)
                out1 = false;
                out2 = false;
        end

        function [out1,out2] = getOutputDataTypeImpl(obj)
            t = propagatedInputDataType(obj,1);
            disp([gcb '/getOutputDataTypeImpl'])
            if isempty(t)
                disp('*no t');
                out1='';
                out2='';
                return;
            end
            disp(t)
            
            out2 = 'double';
            if isempty(t)
                out1= [];
            else
                [type] = decodeOpaqueTypeName(t);
                out1 = type;
            end
        end

    end
end
