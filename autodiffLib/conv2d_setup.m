classdef conv2d_setup < matlab.System &     matlab.system.mixin.Propagates
    % conv2d_setup
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties
        padding = -1;
        stride = [1,1,1,1]
    end

    properties(DiscreteState)
    
    end

    % Pre-computed constants
    properties(Access = private)
        xshape
        shape_BP_KC
        Sel_PKC_IC
        Zero_Ph_Pw
    end

    methods(Access = protected)
        function [w,shape_BPKC,shapeP] = computeSomething(obj,state)
            xra = propagatedInputSize(obj,2); % X
            xla = propagatedInputSize(obj,1); % W

            if isempty(xla)
                %disp(sprintf('conv2d_setup(%d): %s no input',state,gcb));
                w = [];
                shape_BPKC = [];
                shapeP = [];
                return;
            end
            xl = ones(1,4);
            xl(1:numel(xla)) = xla;
            xr = ones(1,4);
            xr(1:numel(xra)) = xra;

            % Fh Fw Fi Fo
            h_filter = xr(1); 
            w_filter = xr(2);
            stride = obj.stride(1);
            [padding,sizeout,offsetout] = paddingsetup([xl(2) xl(3)],[h_filter,w_filter],obj.stride(2:3),obj.padding);


            % Input:  B Ih Iw C
            % Output: B Ph Pw C
            % Patch Representation: B Ph Pw Kh Kw C
            %   the product is against: W as  [Kh Kw C Q]
            %   and we work in 2D: (B Ph Pw) (Kh Kw C) by (Kh Kw C) (Q)
            [w,shape_BPKC,shapeP] = mpatchprepare(xl,[h_filter w_filter],[stride stride],padding, 'BPKC'); % N independent

            %disp(sprintf('conv2d_setup(%d): %s input shapeP',state,gcb));
            %disp(xla)
            %disp(shapeP)

        end

        function setupImpl(obj)
            sXa = propagatedInputSize(obj,1);
            sWa = propagatedInputSize(obj,2);
            sX = ones(1,4);
            sX(1:numel(sXa)) = sXa;

            sW = ones(1,4);
            sW(1:numel(sWa)) = sWa;

            [w,shape_BPKC,shapeP] = obj.computeSomething(1);
            obj.Sel_PKC_IC = w.pickidx;
            obj.shape_BP_KC = int32([prod(shape_BPKC(1:2)), prod(shape_BPKC(3:5))]);
            obj.xshape = int32([sX(1) shapeP(1) shapeP(2) sW(4)]);
            obj.Zero_Ph_Pw = zeros(shapeP,'logical'); % fake
        end
                
        function  [p1,p2] = isOutputFixedSizeImpl(obj)
            p1 = true; 
            p2 = true;
        end
        
        function [p1,p2] = getOutputDataTypeImpl(obj)
            p1 = 'int32';
            p2 = 'logical';
        end

        function [p1,p2] = isOutputComplexImpl(obj)
            p1 = false;
p2 = false;
        end

        % outputs mask and y are same size
        function [Sel_PKC_IC,Zero_Ph_Pw] = getOutputSizeImpl(obj) 
            [w,shape_BPKC,shapeP] = obj.computeSomething(2);
            Sel_PKC_IC = size(w.pickidx); % decided only after SETUP
            Zero_Ph_Pw = shapeP;
        end

        function [Sel_PKC_IC,Zero_Ph_Pw] = stepImpl(obj,X,W)
            Sel_PKC_IC = obj.Sel_PKC_IC;
            Zero_Ph_Pw = obj.Zero_Ph_Pw;
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
