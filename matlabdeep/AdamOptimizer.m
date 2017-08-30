classdef AdamOptimizer < Optimizer
    %Kingma et. al., 2014 (pdf).
    
%TensorFlow: learning_rate=0.001, beta1=0.9, beta2=0.999, epsilon=1e-08.
%Keras: lr=0.001, beta_1=0.9, beta_2=0.999, epsilon=1e-08, decay=0.0.
%Blocks: learning_rate=0.002, beta1=0.9, beta2=0.999, epsilon=1e-08, decay_factor=1.
%Lasagne: learning_rate=0.001, beta1=0.9, beta2=0.999, epsilon=1e-08
%Caffe: learning_rate=0.001, beta1=0.9, beta2=0.999, epsilon=1e-08
%MxNet: learning_rate=0.001, beta1=0.9, beta2=0.999, epsilon=1e-8
%Torch: learning_rate=0.001, beta1=0.9, beta2=0.999, epsilon=1e-8
    properties
        learningrate
        variables
        beta1
        beta2
        epsilon
        locking
        precision 
        integermode
        step
        xtype
               
    end
    
    properties (Transient)
        t
        m_t
        v_t
        s_t
    end
    
    methods 
        function obj = AdamOptimizer(learningrate,target)
            obj = obj@Optimizer();
            obj.beta1 = 0.9;
            obj.beta2 = 0.999;
            obj.integermode = 0;
            obj.epsilon = 1e-8;
            obj.xtype = obj.setgetDefaultType();
            obj.step = 1;
            obj.locking = 0;
            obj.precision = learningrate;
            obj.target = target;
            vc = VariableCollector();
            obj.variables = vc.collect(target);
            fprintf('Parameters %f\n',vc.paramcount());
            obj.m_t = cell(length(obj.variables),1);
            obj.s_t = cell(length(obj.variables),1);
            for I=1:length(obj.variables)
                v = obj.variables{I}.xvalue;
                p =  mzeros(size(v),obj.xtype);
                obj.m_t{I} = p;
                obj.s_t{I} = p;
            end
            obj.t = 1;
            %obj.hardreset(); % removed due to codegen
            target.reset();
            
        end
        
        % increments at step 1 for every epoch and preserves the value of t
        % inside every epoch
        function setbatches(obj,batches)
            obj.integermode = 1;
            obj.step = 1/batches;
        end
        
        function hardreset(obj)
             obj.t = 1;
            for I=1:length(obj.variables)
                v = obj.variables{I}.xvalue;
                obj.m_t{I} = mzeros(size(v),obj.xtype);
                obj.s_t{I} = obj.m_t{I};
            end
        end
           
        
        % step using pairs of cell arrays
        function loss = eval(obj)
                       
            obj.target.reset();
            %obj.target.evalshape();
            loss = obj.target.eval();
            obj.target.grad(1);

            beta1 = obj.beta1;
            beta2 = obj.beta2;
            if obj.integermode
                it = floor(obj.t);
            else
                it = obj.t;
            end
            % bias correction is here
            lr_t = -obj.precision * sqrt(1 - beta2^it) / (1 - beta1^it);
            for I=1:length(obj.variables)
                g = obj.variables{I}.xgrad;
                obj.m_t{I} = beta1*obj.m_t{I}+ (1-beta1)*g;
                obj.s_t{I} = beta2*obj.s_t{I}+ (1-beta2)*g.*g;
                obj.variables{I}.increment(lr_t * obj.m_t{I} ./ (sqrt(obj.s_t{I}) + obj.epsilon));
            end
            
            obj.t = obj.t + obj.step;
        end
    end
   
    
end

