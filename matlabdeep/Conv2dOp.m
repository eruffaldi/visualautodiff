classdef Conv2dOp < BinaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        stride
        matlabconv
        padding 
        outshape
        Sel
        sXp
        Xp
    end
    
    methods
        % [batch, in_height, in_width, in_channels]
        % [filter_height, filter_width, in_channels, out_channels]
        function obj = Conv2dOp(x,W,stride,pad)
            assert(all(stride==1),'only stride 1');
            assert(strcmp(pad,'SAME'),'only pad SAME');
            assert(isa(W,'Variable'),'W should be variable');
            assert(length(W.xshape) == 4,'W should have 4D shape: K K 1 F');
            obj = obj@BinaryOp(x,W);
            obj.stride = stride;
            obj.matlabconv = 1;
            obj.padding = -1;
        end
        
        function r = evalshape(obj)
            xl = obj.left.evalshape();
            xr = obj.right.evalshape();
            assert(length(xl) == 4);
            assert(length(xr) == 4);
            assert(xl(4) == xr(3),'in_channel same');
            
            % Fh Fw Fi Fo
            h_filter = xr(1);
            w_filter = xr(2);
            padding = obj.padding;
            stride = obj.stride(1);
            if obj.padding == -1
                paddingh = (h_filter-1)/2;
                paddingw = (w_filter-1)/2;
            else
                paddingh = padding;
                paddingw = padding;
            end
            [obj.Sel,obj.sXp,obj.outshape] = mpatchprepare(xl,[h_filter w_filter],[stride stride],[paddingh,paddingw]); % N independent
            r = [xl(1) obj.outshape(1) obj.outshape(2) xr(end)];
            obj.xshape = r;
        end
        
        
        function r = eval(obj)
            A = obj.left.eval();
            W = obj.right.eval();
            xs = obj.left.xshape;
            nB = size(A,1);
            nFo = size(W,4);
            
            Xp = mpatcher(A,obj.Sel,obj.sXp); 
            % [nB , Fh Fw nC patches] -> [nB patches Fh Fw C]
            Y = reshape(reshape(Xp,nB*obj.sXp(2),[])*reshape(W,[],nFo),nB,obj.outshape(1),obj.outshape(2),nFo);
            obj.Xp = Xp;
            obj.xvalue = Y;
            r = Y;
        end
        
        
        function grad(obj,up)
            dzdx = mzeros(obj.left.xshape);
            dzdW = mzeros(obj.right.xshape);
            Y = obj.xvalue;
            nC = size(Y,4);
            filtersize =10; % 
            nS = filtersize*filtersize*nC;
            
            dout = sum(up,4); % N Ph Pw Fo incoming => N Ph Pw
            dxcol = mzeros([nB*prod(obj.outshape),filtersize^2*nC]); % [nB*nP, nS] aka size(w)
            % max_idx is [nB Ph Pw Fo] with value 1..nS with nS=Fw Fh nC
            max_idx = randi([1,nS],1,size(dxcol,1));

            % dout flattened: nB nP having summed by Fo
            % dxcol is: nBnP,nS indexed by max_idx
            dxcol(sub2ind(size(dxcol),1:length(max_idx),max_idx)) = dout(:); 
            dzdx = munpatcher(dxcol,obj.Sel,obj.left.xshape);
            obj.left.grad(dzdx);

            dzdWt = reshape(dout,size(dout,1),size(dout,2)*size(dout,3)) * obj.Xp';
            dzdW = reshape(dzdWt,obj.right.xshape);
          
            obj.right.grad(dzdW);
        end
        
    end
    
end

