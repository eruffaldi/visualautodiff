classdef dropout23_sys < matlab.System %& matlab.system.mixin.Propagates
    % dropout23_sys Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties

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

        function [y,mask] = stepImpl(obj,x,rate)
            if rate == 1.0
                y = x;
                mask = ones(size(x),'like',x);
            else
                pa = [size(x,1),size(x,2),size(x,3)]; % not on last
                q = (rand(pa, 'single') >= rate);
                realrate = sum(q(:) == false)/prod(pa);
                scale = (1 / (1 - realrate));
                mask0 = scale * q;
                mask = repmat(mask0,1,1,1,size(x,4));
                y = mask .* x;
            end
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

        % outputs mask and y are same size
        function [sz_y,sz_mask] = getOutputSizeImpl(obj) 
            sz_y =  propagatedInputSize(obj,1); 
            sz_mask = sz_y;
        end
        

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
