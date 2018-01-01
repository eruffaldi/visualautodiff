classdef toOpaque < matlab.System &  matlab.system.mixin.Propagates
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
     OutputBus; 

    end
    methods
        function obj=toOpaque(varargin)
                  setProperties(obj,nargin,varargin{:});
        end
        
    end

    methods(Access = protected)
        
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
        end

        function y = stepImpl(obj,u)
            y.value = zeros([1,2],'uint32');
        end
    function out = isOutputFixedSizeImpl(obj)
      out = propagatedInputFixedSize(obj, 1);
    end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
        

        function out = getOutputSizeImpl(obj)
            
                out = 1;
        end

        function out = isOutputComplexImpl(obj)
          out = false;
        end

        function out = getOutputDataTypeImpl(obj)
            t = propagatedInputDataType(obj,1);
            s = propagatedInputSize(obj,1);
            %
            out= strrep(strrep([gcb '_bus'],'/','_'),' ','_');
            if isempty(t)
                disp([gcb ' getOutputDataTypeImpl - no type'])
                  [~,out]= createOpaqueTypeBus([],[],out);
            else                
                disp([gcb ' getOutputDataTypeImpl - with type'])
                disp(t);
                if isempty(s)
                    disp([gcb ' getOutputDataTypeImpl - no size'])
                else
                    disp([gcb ' getOutputDataTypeImpl - with size'])
                    disp(s);
                  [~,out]= createOpaqueTypeBus(t,s,out);
                end
            end
                disp([gcb ' getOutputDataTypeImpl - quit ' out])
        end

    end
end
