classdef maxpool_setup < matlab.System
    % untitled4 Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties
        ksize = [1,2,2,1];
        strides = [1,2,2,1];
    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(Access = private)
        Sel_PCK_IC
        shapeP
        shape_BPC_K
        argmaxbase
        argmaxbasescale
    end

    methods(Access = protected)
        function setupImpl(obj)
            xl = propagatedInputSize(obj,1);
            
            if length(xl) == 3
                nC = 1;
            else
                nC = xl(4);
            end

            % General case
            h_filter = obj.ksize(2);
            w_filter = obj.ksize(3);
            
            %paddingmode = obj.padding;
            if 1==1 % strcmp(paddingmode,'SAME')
                padding = [0,0, 0,0]; % special h_filter-1,w_filter-1];
            else
                %padding = paddingmode;
            end
            [obj.Sel_PCK_IC,~,obj.shapeP] = mpatchprepare(xl,[h_filter w_filter],[obj.strides(2) obj.strides(3)],padding,'BPCK'); % N independent
            r = [xl(1) obj.shapeP(1) obj.shapeP(2) nC]; % output BPC
            obj.xshape = r;            
            
            obj.shape_BPC_K = [prod(r) h_filter*w_filter]; % patches for max: BPC K
            [obj.argmaxbase,obj.argmaxbasescale] = argmax_to_max_setup(obj.shape_BPC_K,2); 
        end

        function [Sel_PCK_IC,xshape,shape_BPC_K,argmaxbase,argmaxbasescale] = stepImpl(obj,X)
            Sel_PCK_IC = obj.Sel_PKC_IC;
            xshape = obj.xshape;
            shape_BPC_K = obj.shape_BPC_K;    
            argmaxbase = obj.argmaxbase;
            argmaxbasescale = obj.argmaxbasescale;
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
