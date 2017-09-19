classdef maxpool_setup < matlab.System & matlab.system.mixin.Propagates
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
        Sel_PCK_IC_A
        shapeP
        shape_BPC_K
        Zero_Ph_Pw
        argmaxbase
        argmaxbasescale
    end

    methods(Access = protected)
        function [Sel_PCK_IC,shape_BPC_K,shapeP,Sel_PCK_IC_A] = computeSomething(obj)
            xla = propagatedInputSize(obj,1);
            if isempty(xla)
                w = [];
                shape_BPC_K = [];
                shapeP = [];
                return;
            end
            
            if length(xla) == 3
                xl = [xla,1];
            else
                xl = xla;
            end
            nC = xl(4);

            % General case
            h_filter = obj.ksize(2);
            w_filter = obj.ksize(3);
            
            %paddingmode = obj.padding;
            if 1==1 % strcmp(paddingmode,'SAME')
                padding = [0,0, 0,0]; % special h_filter-1,w_filter-1];
            else
                %padding = paddingmode;
            end
            [w,~,shapeP] = mpatchprepare(xl,[h_filter w_filter],[obj.strides(2) obj.strides(3)],padding,'BPCK'); % N independent
            r = [xl(1) shapeP(1) shapeP(2) nC]; % output BPC
            %obj.xshape = r;            
            Sel_PCK_IC_A = int32(1);
            Sel_PCK_IC = w.pickidx;
            
            shape_BPC_K = [prod(r) h_filter*w_filter]; % patches for max: BPC K
        end
        
        function setupImpl(obj)
            [obj.Sel_PCK_IC,obj.shape_BPC_K,obj.shapeP,obj.Sel_PCK_IC_A] = obj.computeSomething();
            [obj.argmaxbase,obj.argmaxbasescale] = argmax_to_max_setup(obj.shape_BPC_K,2); 
            obj.argmaxbase = cast(obj.argmaxbase,'int32');
            obj.argmaxbasescale = cast(obj.argmaxbasescale,'int32');
            obj.Zero_Ph_Pw = false(obj.shapeP(:)');
            
        end
        
         function  [p1,p2,p3,p4,p5] = isOutputFixedSizeImpl(obj)
            p1 = true; 
            p2 = true;
            p3 = true;
            p4 = true;
            p5 = true;
        end
        
        function [p1,p2,p3,p4,p5] = getOutputDataTypeImpl(obj)
            p1 = 'int32';
            p2 = 'int32';
            p3 = 'int32';
            p4 = 'logical';
            p5 = 'int32';
        end

        function [p1,p2,p3,p4,p5] = isOutputComplexImpl(obj)
            p1 = false;
            p2 = false;
            p3 = false;
            p4 = false;
            p5 = false;
        end

        % outputs mask and y are same size
        function [Sel_PCK_IC,argmaxbase,argmaxbasescale,Zero_Ph_Pw,Sel_PCK_IC_A] = getOutputSizeImpl(obj) 

            [w,shape_BPC_K,shapeP,wa] = obj.computeSomething();
            if isempty(w)
                Sel_PCK_IC= [];
                Sel_PCK_IC_A = [];
                argmaxbase = 0;
                argmaxbasescale = 0;
                Zero_Ph_Pw = 0;
                return;
                
            end
            
            Sel_PCK_IC = size(w); % decided only after SETUP
            Sel_PCK_IC_A = 1; %size(wa);
            Zero_Ph_Pw = shapeP;
            [ab,abs] = argmax_to_max_setup(shape_BPC_K,2); 
            argmaxbasescale = size(abs);
            argmaxbase =size(ab);
        end


        function [Sel_PCK_IC,argmaxbase,argmaxbasescale,Zero_Ph_Pw,Sel_PCK_IC_A] = stepImpl(obj,X)
            Sel_PCK_IC = obj.Sel_PCK_IC;
            Sel_PCK_IC_A = obj.Sel_PCK_IC_A;
            Zero_Ph_Pw = obj.Zero_Ph_Pw;
            argmaxbase = obj.argmaxbase;
            argmaxbasescale = obj.argmaxbasescale;
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
