classdef softmax_cross_entropy_with_logits < BinaryOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    % Original TF
    % https://github.com/tensorflow/tensorflow/blob/4433079e7f317724eaa92ec120c6b1c3c0c52f2f/tensorflow/contrib/nn/python/ops/cross_entropy.py
    %   Deprecated in favor of tf.nn.softmax_cross_entropy_with_logits
    %   https://github.com/tensorflow/tensorflow/blob/398699286064bc0821056209e1c62065f0e00f82/tensorflow/python/ops/nn_ops.py
    % Calling C++
    %    https://github.com/tensorflow/tensorflow/blob/master/tensorflow/core/kernels/xent_op.cc
    %    (PART)
    %    
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
            assert(~isempty(r));
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
            assert(~isempty(obj.left.xvalue));
            assert(~isempty(obj.right.xvalue));
            % if up we reduce 
            % backprop: prob - labels
            %   prob = exp(logits - max_logits) / sum(exp(logits - max_logits))
            classes = size(obj.logits.xvalue,2);
            J = (exp(obj.logitsoffsetted) ./ repmat(obj.sumx,1,classes))-obj.labels.xvalue;
            obj.logits.grad(up*J);
        end
        
    end
    
end



