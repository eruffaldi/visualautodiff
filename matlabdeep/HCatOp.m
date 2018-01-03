classdef HCatOp < NAryOp 

    properties
        otype       
        oindices
    end
    methods
        function obj = HCatOp(varargin)
            obj = obj@NAryOp(varargin{:});
            obj.otype = DeepOp.setgetDefaultType();
        end

          function gradshape(obj,ts)
              warning('HCatOp.gradshape not implemented');
%             cellfun(@(x) x.gradshape(ts),obj.children);
        end

        function evalshape(obj)
            vs = cellfun(@(x) x.evalshape(),obj.children());
            s1 = vs{1}(1);
            assert(all(cellfun(@(x) length(x) == 2,vs)),'all matrices');
            assert(all(cellfun(@(x) x(1) == s1,vs)),'all same column size');
            ss = cellfun(@(x) x(2) == s1,vs);
            obj.oindices = cumsum(ss);
            obj.xshape = [s1,sum(ss)];
            
            % TODO type
            
        end

        function r = eval(obj)
            r = mzeros(obj.xshape,obj.otype);
            K=1;
            for I=1:length(obj.children)
                rI = obj.children{I}.eval();
                r(:,K:K+size(rI,1)-1) = rI;
                K = K + size(rI,2);
            end
            obj.xvalue = r;
        end

        function grad(obj,up)
            K=1;
            for I=1:length(obj.children)
                nI = obj.children{I}.xshape(1);
                obj.children{I}.grad(up(:,K:K+nI));
                K = K + nI;
            end
        end

    end
    
end

