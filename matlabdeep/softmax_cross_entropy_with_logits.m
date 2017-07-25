classdef softmax_cross_entropy_with_logits < BinaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        labels
        logits
    end
    
    methods
        function obj = softmax_cross_entropy_with_logits(labels,logits)
            obj = obj@BinaryOp(labels,logits);
            obj.labels = labels;
            obj.logits = logits;
        end
        
        function r = eval(obj)
            xl =obj.labels.eval();
            xr = obj.logits.eval();
            obj.xvalues = xl; % TODO
            r = obj.xvaues;            
        end
        
        function r = evalshape(obj)
             sl =obj.labels.evalshape();
             sr = obj.logits.evalshape();
             assert(all(sl == sr),'same inputs in softmax');
             obj.xshape = obj.labels.xshape;
             r = obj.xshape;
        end
        
        function grad(obj,up)
            error('softmax_cross_entropy_with_logits not implemented');
        end
        
    end
    
end
