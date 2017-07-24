classdef MaxPoolOp < DeepOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        left
        ksize
        strides
        pad
    end
    
    methods
        function obj = MaxPoolOp(x,ksize,strides,pad)
            assert(all(ksize == [1,2,2,1]),'only size [1,2,2,1]');
            assert(all(strides == [1,2,2,1]),'only size [1,2,2,1]');
            assert(strcmp(pad,'SAME'),'only pad SAME');
            obj = obj@DeepOp();
            obj.left = x;
            obj.ksize = ksize;
            obj.strides = strides;
            obj.pad = pad;
        end
        
        function r = eval(obj)
        end
        
        function r = evalshape(obj)
        end
        
        function grad(obj,up)
        end
        
        function gradshape(obj,up)
        end
    end
    
end

