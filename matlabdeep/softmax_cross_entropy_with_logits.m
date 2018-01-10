classdef softmax_cross_entropy_with_logits < BinaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    % Original TF
    % https://github.com/tensorflow/tensorflow/blob/4433079e7f317724eaa92ec120c6b1c3c0c52f2f/tensorflow/contrib/nn/python/ops/cross_entropy.py
    %   Deprecated in favor of tf.nn.softmax_cross_entropy_with_logits
    %   https://github.com/tensorflow/tensorflow/blob/398699286064bc0821056209e1c62065f0e00f82/tensorflow/python/ops/nn_ops.py
    % Calling C++
    %    https://github.com/tensorflow/tensorflow/blob/master/tensorflow/core/kernels/xent_op.h
    %    (PART)
    %    
    
    % // max_logits along classes.
    %scratch.reshape(batch_only).device(d) = logits.maximum(along_class);
    %// logits - max_logits.
    %backprop.device(d) = logits - scratch.broadcast(one_by_class);
    %// sum(exp(logits - max_logits)) along classes.
    %scratch.reshape(batch_only).device(d) = backprop.exp().sum(along_class);
    %loss.device(d) =
     %   (labels * (scratch.log().eval().broadcast(one_by_class) - backprop))
     %       .eval()
     %       .sum(along_class);
    %// backprop: prob - labels, where
    %//   prob = exp(logits - max_logits) / sum(exp(logits - max_logits))
    %backprop.device(d) =
     %   (backprop.exp() / scratch.broadcast(one_by_class)) - labels;
        
    properties
        labels
        logits
        classdim
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
            obj.classdim = 1;
        end
        
        function r = eval(obj)
            xlabels = obj.labels.eval();
            xlogits = obj.logits.eval();
            classdim = obj.classdim;
            nclasses = size(xlogits,classdim);
            logitsmax = max(xlogits,[],classdim); % along class => logitsmax is Bx1
            if classdim == 2   % B,C
                obj.logitsoffsetted = xlogits - repmat(logitsmax,1,nclasses); % broadcast class
            else
                obj.logitsoffsetted = xlogits - repmat(logitsmax,nclasses,1); % broadcast class
            end            
            obj.sumx = sum(exp(obj.logitsoffsetted),classdim); % scratch is Bx1
            if classdim == 2
                bscratch = repmat(log(obj.sumx),1,nclasses);
            else
                bscratch = repmat(log(obj.sumx),nclasses,1);
            end
            loss = sum(xlabels .* (bscratch - obj.logitsoffsetted),classdim); 
            obj.xvalue = loss;
            r = loss;
            assert(~isempty(r));
        end
        
        function r = evalshape(obj)
             sl = obj.labels.evalshape();
             sr = obj.logits.evalshape();
             assert(length(sl) == 2,'only (batch,classes)');
             assert(all(sl == sr),'same inputs in softmax');
             if obj.classdim == 2
                 obj.xshape = obj.labels.xshape(2:end); % remove first batch size
             else
                 obj.xshape = obj.labels.xshape(1:end-1); % remove last batch size
             end
             r = obj.xshape;
        end

        
        function grad(obj,up)
            assert(~isempty(obj.left.xvalue));
            assert(~isempty(obj.right.xvalue));
            % if up we reduce 
            % backprop: prob - labels
            %   prob = exp(logits - max_logits) / sum(exp(logits - max_logits))
            classes = size(obj.logits.xvalue,obj.classdim);
            if obj.classdim == 2
                J = (exp(obj.logitsoffsetted) ./ repmat(obj.sumx,1,classes))-obj.labels.xvalue;
            else
                J = (exp(obj.logitsoffsetted) ./ repmat(obj.sumx,classes,1))-obj.labels.xvalue;
            end
            obj.logits.grad(up*J);
        end
       
                function r = gradshape(obj,up)
        end
        

    end
    
end



