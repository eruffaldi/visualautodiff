classdef softmax_cross_entropy_with_logits < BinaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        labels
        logits
    end
    
    properties (Transient)
        back
    end
    
    methods
        % cross entropy loss is
        % H(p,q) = - Sum p(x) log q(x)
        function obj = softmax_cross_entropy_with_logits(labels,logits)
            obj = obj@BinaryOp(labels,logits);
            obj.labels = labels;
            obj.logits = logits;
        end
        
        function r = eval(obj)
            xla = obj.labels.eval();
            xlo = obj.logits.eval();
            classes = size(xlo,2);
            classdim = 2;
            
            lm = max(xlo,[],classdim); % along class
            xback = xlo - repmat(lm,1,classes); % broadcast class
            scratch = sum(exp(xback),2); % exp and sum along class
            loss = sum((xla .* (repmat(log(scratch),1,classes) - xback)),classdim); 
            obj.back = (exp(xback) ./ repmat(scratch,1,classes))-xla;
            obj.xvalue = loss;
            r = loss;
        end
        
        function r = evalshape(obj)
             sl = obj.labels.evalshape();
             sr = obj.logits.evalshape();
             assert(length(sl) == 2,'only (batch,classes)');
             assert(all(sl == sr),'same inputs in softmax');
             obj.xshape = obj.labels.xshape(2:end); % remove first batch size
             r = obj.xshape;
        end
        
        function grad(obj,up)
            % being a loss it is terminal 
            obj.logits.grad(obj.back);
        end
        
    end
    
end



