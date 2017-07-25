classdef softmax_cross_entropy_with_logits < DeepOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        labels
        logits
    end
    
    methods
        function obj = softmax_cross_entropy_with_logits(labels,logits)
            obj = obj@DeepOp();
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
             obj.labels.evalshape();
             obj.logits.evalshape();
             obj.xshape = obj.labels.xshape;
             r = obj.xshape;
        end
        
        function grad(obj,up)
        end
        
        function gradshape(obj,up)
        end
    end
    
end
