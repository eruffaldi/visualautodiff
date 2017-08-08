classdef MaxPoolOp < UnaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ksize
        strides
        padding
        xtype
    end
    
    % We define the following:
    % B = batch
    % I = input space = Fh Fw C
    % K = kernel space = Kh Kw C (over which we do max)
    % P = patch space = Ph Pw C  (the output)
    %
    % We do the transformations (independent of shape):
    % - X input: B I
    % - Xp patches: B P C K
    % - Xo output:  B P C
    properties (Transient)
        shape_BPC_K
        shapeP
        Sel_PCK_IC
        maxindices_BPC
        argmaxbase
        argmaxbasescale
    end
    
    methods
        % Tensorflow supports NHWC or NCHW => we NHWC
        % padding see https://www.tensorflow.org/api_docs/python/tf/nn/convolution
        function obj = MaxPoolOp(x,ksize,strides,pad)
            assert(all(ksize == [1,2,2,1]),'only size [1,2,2,1]');
            %assert(all(strides == [1,2,2,1]),'only size [1,2,2,1]');
            assert(strcmp(pad,'SAME'),'only pad SAME');
            obj = obj@UnaryOp(x);
            obj.ksize = ksize;
            obj.strides = strides;
            obj.xtype = DeepOp.setgetDefaultType();
            obj.padding = pad;
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
            [obj.Sel_PCK_IC,~,obj.shapeP] = mpatchprepare(xl,[h_filter w_filter],[obj.strides(2) obj.strides(3)],padding,'BPCK'); % N independent
            r = [xl(1) obj.shapeP(1) obj.shapeP(2) xl(4)]; % output BPC
            obj.xshape = r;            
            
            obj.shape_BPC_K = [prod(r) h_filter*w_filter]; % patches for max: BPC K
            [obj.argmaxbase,obj.argmaxbasescale] = argmax_to_max_setup(obj.shape_BPC_K,2); 
        end

        % [batch fw fh channels]
        function r = eval(obj)
            X_BIC = obj.left.eval();
            
            % [nB Ph Pw Fin] => [nB patches, Fh Fw Fin]
            Xp_BPC_K = mpatcher(X_BIC,obj.Sel_PCK_IC,obj.shape_BPC_K);
            % => [nB patches]
            [Y_BPC,Yind_BPC] = max(Xp_BPC_K,[],2);
                            
            obj.xvalue = reshape(Y_BPC,obj.xshape);
            obj.maxindices_BPC = Yind_BPC; % in [nB P, S]
            r = obj.xvalue;
        end
        
        function grad(obj,up_BPC)
            
            % [nB
            Jp_BPC_K = mzeros(size(obj.shape_BPC_K),obj.xtype); % empty patches            
            ind = obj.argmaxbase + (obj.maxindices_BPC(:)-1)*obj.argmaxbasescale; % winning indices from eval step
            
            %Alternative: dxcol(sub2ind(size(dxcol),1:length(max_idx),max_idx)) = dout(:); 
            
            % ?? => [nB patches]  TODO
            % => [nB patches, Fh Fw Fin] via assignment
            Jp_BPC_K(ind) = up_BPC;  % propagate up to them
            
            % => [nB Ph Pw Fin] via unpatching
            J_BIC = munpatcher(Jp_BPC_K,obj.Sel_PCK_IC,obj.left.xshape); % aggregate contributions
            obj.left.grad(J_BIC);
        end
    end
    
end

