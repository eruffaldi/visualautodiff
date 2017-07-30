classdef softmax_cross_entropy_with_logits < BinaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        labels
        logits
    end
    
    properties (Transient)
        logitsoffsetted
        sumx
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
            xlabels = obj.labels.eval();
            xlogits = obj.logits.eval();
            classes = size(xlogits,2);
            classdim = 2;
            
            logitsmax = max(xlogits,[],classdim); % along class
            obj.logitsoffsetted = xlogits - repmat(logitsmax,1,classes); % broadcast class
            scratch = sum(exp(obj.logitsoffsetted),classdim); % exp and sum along class
            loss = sum((xlabels .* (repmat(log(scratch),1,classes) - obj.logitsoffsetted)),classdim); 
            obj.xvalue = loss;
            obj.sumx = scratch;
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
            % if up we reduce 
            % backprop: prob - labels
            %   prob = exp(logits - max_logits) / sum(exp(logits - max_logits))
            classes = size(obj.logits.xvalue,2);
            J = (exp(obj.logitsoffsetted) ./ repmat(obj.sumx,1,classes))-obj.labels.xvalue;
            obj.logits.grad(up*J);
        end
        
    end
    
end



