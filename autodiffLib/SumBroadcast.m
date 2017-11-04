classdef SumBroadcast < matlab.System & matlab.system.mixin.Propagates 
    
    % SumBroadcast

    % Public, tunable properties
    properties

    end

    % Public, non-tunable properties
    properties(Nontunable)

    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(Nontunable,Access = private)
        w
    end

    methods
        % Constructor
        function obj = SumBroadcast(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj,nargin,varargin{:})
        end
    end

    methods(Access = protected)
        %% Common functions
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            sl = propagatedInputSize(obj,1);
            %ROW-MAJOR obj.w = [prod(sl(1:end-1)) sl(end)]; %
            %A1=B,A2,...,An ==> A1=B A2 ... An-1, An
            obj.w = [sl(1) prod(sl(2:end))]; % A1...,An=B =>  A1, A2 ... An=B

        end

        function y = stepImpl(obj,ul,ur)
            sl = size(ul); % A1,...,An e.g. 100x10
            % sr = An,1 or 1,An
            %if coder.target('MATLAB')
        %ROW MAJOR: y = reshape(reshape(ul,obj.w) + repmat(ur(:)',obj.w(1),1),sl);
        y = reshape(reshape(ul,obj.w) + repmat(ur(:),1, obj.w(2)),sl);
                
                
            %else
                % make output not initialized
%                 ty = coder.nullcopy(zeros(obj.w,'like',ul));
%                 tul = reshape(ul,obj.w);
%                 for I=1:obj.w(1) % row
%                     %for J=1:obj.w(2) % column, shared with right
%                     %    y(I+J*obj.w(1)) = ul(I+J*obj.w(1)) + ur(J);  % along all )
%                     %end
%                     ty(I,:) = tul(I,:) + ur(:)';
%                 end
%                 y = reshape(ty,sl);
            %end
        end
        function [sz,dt,cp] = getDiscreteStateSpecificationImpl(obj,propertyname)
            sz = [1,2];
            dt = 'double';
            cp = false;
        end
        function [p1]= isOutputFixedSizeImpl(obj)
            p1 = true;
        end
        function [p1] = getOutputDataTypeImpl(obj)
            p1 = propagatedInputDataType(obj,1);
        end
        function out = getOutputSizeImpl(obj)
            out = propagatedInputSize(obj,1);
        end
        function [p1] = isOutputComplexImpl(obj)
            p1 = false;
        end

    end

end
