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
        Sel_PCK_IC
        maxindices_BPC

        shape_K_CPB
        Sel_IC_KCP
        maxindices_CPB

        shapeP
        argmaxbase
        colmajor
        argmaxbasescale
    end
    
    methods
        % Tensorflow supports NHWC or NCHW => we NHWC
        % padding see https://www.tensorflow.org/api_docs/python/tf/nn/convolution
        function obj = MaxPoolOp(x,ksize,strides,pad,colmajor)
            if nargin < 5
                colmajor = 1;
            end
            assert(ksize(1) == 1 & ksize(end) == 1);
            %assert(all(strides == [1,2,2,1]),'only size [1,2,2,1]');
            assert(strcmp(pad,'SAME'),'only pad SAME');
            obj = obj@UnaryOp(x);
            obj.ksize = ksize;
            obj.strides = strides;
            obj.colmajor = colmajor;
            obj.xtype = DeepOp.setgetDefaultType();
            obj.padding = -1; %strcmp(pad,'SAME') ;
        end

        function r = evalshape(obj)
            xl =oneextend4(obj.left.evalshape());
                        
            if obj.colmajor
                flipper = @(x) x(end:-1:1);
                inmode= 'CWHB';
                procmode='hwCWHB';
                tdim = 1;
            else
                flipper = @(x) x;
                tdim = 2;
                inmode= 'BHWC';
                procmode='BHWCwh';
            end
            
            xll = flipper(xl);
            kl = flipper(obj.ksize);
            nB = xll(1);
            h_image =  xll(2);
            w_image = xll(3);
            nC = xll(4);
            h_filter = kl(2);
            w_filter = kl(3);
            
            [paddingout, sizeout, offsetout] = paddingsetup([h_image,w_image],[h_filter,w_filter],obj.strides(2:3),obj.padding);

            mm = mpatchprepare(inmode,xl,[h_filter w_filter],sizeout,[obj.strides(2) obj.strides(3)],paddingout,procmode,obj.colmajor); % N independent
            r = flipper([nB mm.outshape.H mm.outshape.W nC]);
            
            if obj.colmajor
                assert(length(mm.pickidx) == mm.outshapegroup.H*mm.outshapegroup.W*mm.outshapegroup.C);
                obj.Sel_IC_KCP = mm;
            
                obj.shape_K_CPB = [mm.outshape.w*mm.outshape.h prod(r) ]; % patches for max: BPC K
                tshape = obj.shape_K_CPB;
            else
                assert(length(mm.pickidx) == mm.outshapegroup.H*mm.outshapegroup.W*mm.outshapegroup.C);
                obj.Sel_PCK_IC = mm;

                obj.shape_BPC_K = [prod(r) mm.outshape.w*mm.outshape.h]; % patches for max: BPC K
                tshape = obj.shape_BPC_K;
            end
            [obj.argmaxbase,obj.argmaxbasescale] = argmax_to_max_setup(tshape,tdim); 
            obj.xshape = r;            
        end

        % [batch fw fh channels]
        function r = eval(obj)
            if obj.colmajor
                X_CIB = obj.left.eval();

                % [nB Ph Pw Fin] => [nB patches, Fh Fw Fin]
                Xp_K_CPB = mpatcher(X_CIB,obj.Sel_IC_KCP,obj.shape_K_CPB,obj.colmajor);
                % => [nB patches]
                [Y_CPB,Yind_CPB] = max(Xp_K_CPB,[],1);

                obj.xvalue = reshape(Y_CPB,obj.xshape);
                obj.maxindices_CPB = Yind_CPB; % in [nB P, S]            else
            else
                X_BIC = obj.left.eval();

                % [nB Ph Pw Fin] => [nB patches, Fh Fw Fin]
                Xp_BPC_K = mpatcher(X_BIC,obj.Sel_PCK_IC,obj.shape_BPC_K,obj.colmajor);
                % => [nB patches]
                [Y_BPC,Yind_BPC] = max(Xp_BPC_K,[],2);

                obj.xvalue = reshape(Y_BPC,obj.xshape);
                obj.maxindices_BPC = Yind_BPC; % in [nB P, S]            else
            end
            r = obj.xvalue;
        end
        
        function grad(obj,up)
            
            if obj.colmajor
                % [nB
                up_CPB = up;
                Jp_K_CPB = mzeros(obj.shape_K_CPB,obj.xtype); % empty patches            
                if length(obj.argmaxbase) == 1 % identity case
                    ind = obj.maxindices_CPB(:);
                else
                    ind = obj.argmaxbase + (obj.maxindices_CPB(:)-1)*obj.argmaxbasescale; % winning indices from eval step
                end

                %Alternative: dxcol(sub2ind(size(dxcol),1:length(max_idx),max_idx)) = dout(:); 

                % ?? => [nB patches]  TODO
                % => [nB patches, Fh Fw Fin] via assignment
                Jp_K_CPB(ind) = up_CPB;  % propagate up to them

                % => [nB Ph Pw Fin] via unpatching
                J_CIB = munpatcher(Jp_K_CPB,obj.Sel_IC_KCP,obj.left.xshape,prod(obj.left.xshape(1:end-1)),obj.colmajor); % aggregate contributions
                obj.left.grad(J_CIB);
            else
                up_BPC = up;
                                % [nB
                Jp_BPC_K = mzeros(obj.shape_BPC_K,obj.xtype); % empty patches            
                ind = obj.argmaxbase + (obj.maxindices_BPC(:)-1)*obj.argmaxbasescale; % winning indices from eval step

                %Alternative: dxcol(sub2ind(size(dxcol),1:length(max_idx),max_idx)) = dout(:); 

                % ?? => [nB patches]  TODO
                % => [nB patches, Fh Fw Fin] via assignment
                Jp_BPC_K(ind) = up_BPC;  % propagate up to them

                % => [nB Ph Pw Fin] via unpatching
                J_BIC = munpatcher(Jp_BPC_K,obj.Sel_PCK_IC,obj.left.xshape,prod(obj.left.xshape(2:end)),obj.colmajor); % aggregate contributions
                obj.left.grad(J_BIC);
            end
        end
    
        function r = gradshape(obj,up)
        end
        
        
    end
    
end

