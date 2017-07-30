classdef MaxPoolOp < UnaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ksize
        strides
        padding
    end
    
    properties (Transient)
        maxindices
        Sel
        sXp
        outshape
    end
    
    methods
        % Tensorflow supports NHWC or NCHW => we NHWC
        % padding see https://www.tensorflow.org/api_docs/python/tf/nn/convolution
        function obj = MaxPoolOp(x,ksize,strides,pad)
            assert(all(ksize == [1,2,2,1]),'only size [1,2,2,1]');
            assert(all(strides == [1,2,2,1]),'only size [1,2,2,1]');
            assert(strcmp(pad,'SAME'),'only pad SAME');
            obj = obj@UnaryOp(x);
            obj.ksize = ksize;
            obj.strides = strides;
            obj.padding = pad;
        end
        
        % [batch fw fh channels]
        function r = eval(obj)
            A = obj.left.eval();
            xs = obj.left.xshape;
            r = mzeros(obj.xshape);
            o = mzeros(obj.xshape); 
            ksize = obj.ksize;
            strides = obj.strides; %
                       
            obj.maxindices = o;
            obj.xvalue = r;
        end
        
        function r = evalshape(obj)
            xl = obj.left.evalshape();
           
            % General case
            h_filter = obj.ksize(2);
            w_filter = obj.ksize(3);
            paddingmode = obj.padding;
            if strcmp(paddingmode,'SAME')
                padding = [0,0, 0,0]; % special h_filter-1,w_filter-1];
            else
                padding = paddingmode;
            end
            [obj.Sel,obj.sXp,obj.outshape] = mpatchprepare(xl,[h_filter w_filter],[obj.strides(2) obj.strides(3)],padding); % N independent
            r = [xl(1) obj.outshape(1) obj.outshape(2) xl(4)];
            obj.xshape = r;

        end
        
        function grad(obj,up)
            obj.left.grad(mzeros(obj.left.xshape));
        end
    end
    
end

