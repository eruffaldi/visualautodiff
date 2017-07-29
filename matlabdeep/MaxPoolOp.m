classdef MaxPoolOp < UnaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ksize
        strides
        pad
    end
    
    properties (Transient)
        maxindices
    end
    
    methods
        % Tensorflow supports NHWC or NCHW
        function obj = MaxPoolOp(x,ksize,strides,pad)
            assert(all(ksize == [1,2,2,1]),'only size [1,2,2,1]');
            assert(all(strides == [1,2,2,1]),'only size [1,2,2,1]');
            assert(strcmp(pad,'SAME'),'only pad SAME');
            obj = obj@UnaryOp(x);
            obj.ksize = ksize;
            obj.strides = strides;
            obj.pad = pad;
        end
        
        % [batch fw fh channels]
        function r = eval(obj)
            A = obj.left.eval();
            xs = obj.left.xshape;
            r = mzeros(obj.xshape);
            o = mzeros(obj.xshape); 
            ksize = obj.ksize;
            strides = obj.strides; %
            
            for iB=1:xs(1)
                for iC=1:xs(4) 
                    for iX=1:2:xs(2)-1
                        for iY=1:2:xs(3)-1
                            %[r(iB,iX,iY,iC),o(iB,iX,iY,iC)] = max(A(iB,iX:iX+1,iY:iY+1,iC),W,'same');
                        end
                        % TODO last row for nan
                    end
                    % TODO last column for nan
                end 
            end
            obj.maxindices = o;
            obj.xvalue = r;
        end
        
        function r = evalshape(obj)
            xl = obj.left.evalshape();
            % special case
            obj.xshape = xl./obj.strides; %./obj.ksize;
            r = obj.xshape;
        end
        
        function grad(obj,up)
            obj.left.grad(mzeros(obj.left.xshape));
        end
    end
    
end

