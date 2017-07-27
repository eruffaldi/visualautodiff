classdef AdamOptimizer < Optimizer
    %Kingma et. al., 2014 (pdf).
    
    properties
        learningrate
        target
        variables
        beta1
        beta2
        epsilon
        locking
        
               
    end
    
    properties (Transient)
        t
        m_t
        v_t
    end
    
    methods 
        function obj = AdamOptimizer(learningrate,target)
            obj = obj@Optimizer();
            obj.beta1 = 0.9;
            obj.beta2 = 0.999;
            obj.epsilon = 1e-8;
            obj.locking = False;
            obj.precision = learningrate;
            obj.target = target;
            vc = VariableCollector();
            obj.variables = vc.collect(target);
            disp(sprintf('Parameters %d',vc.paramcount()));
            obj.m_t = cell(length(obj.variables,1));
            obj.s_t = cell(length(obj.variables,1));
            obj.reset();
            target.reset();
        end
        
        function reset(obj)
            obj.t = 0;
            for I=1:length(obj.variables)
                v = obj.variables{I}.xvalue;
                obj.m_t{I} = mzeros(size(v));
                obj.s_t{I} = obj.m_t{I};
            end
        end
           
        
        % step using pairs of cell arrays
        function loss = eval(obj)
            obj.target.reset();
            obj.target.evalshape();
            loss = obj.target.eval();
            obj.target.grad(1);

            lr_t = obj.learning_rate * sqrt(1 - obj.beta2^obj.t) / (1 - obj.beta1^obj.t);
            beta1 = obj.beta1;
            beta2 = obj.beta2;
            for I=1:length(obj.variables)
                g = obj.variables{I}.xgrad;
                obj.m_t{I} = beta1*obj.m_t{I}+ (1-beta1)*g;
                obj.s_t{I} = beta2*obj.s_t{I}+ (1-beta2)*g.*g;
                obj.variable{I}.increment(-lr_t * obj.m_t{I} ./ (sqrt(obj.s_t{I}) + obj.epsilon));
            end
            
            obj.t = obj.t + 1;
        end
    end
   
    
end

