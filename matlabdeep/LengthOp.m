classdef LengthOp < UnaryOp & MixinDelegateUnaryOp
    % Computes the lenght of 
    
    properties
        axis 
    end
    
    methods
        % only full reduction
        function obj = LengthOp(x,axis)                                 
            obj = obj@UnaryOp(SqrtOp(ReduceSumOp(SquareOp(x),axis)));
            obj.axis = axis;
        end
        
        
        function r = evalshape(obj)
            obj.left.evalshape();
            r = obj.left.xshape;
            r(obj.axis) = [];
            obj.xshape = r;
        end
      
    end
    
end

