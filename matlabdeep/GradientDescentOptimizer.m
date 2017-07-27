classdef GradientDescentOptimizer < Optimizer
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        learning_rate
        target
        variables
    end
    
    methods 
        function obj = GradientDescentOptimizer(learning_rate,target)
            obj = obj@Optimizer();
            obj.learning_rate = learning_rate;
            obj.target = target;
            vc = VariableCollector();
            obj.variables = vc.collect(target);
            disp(sprintf('Parameters %d',vc.paramcount()));
            target.reset();
        end
        
        % step using pairs of cell arrays
        function loss = eval(obj)
            obj.target.reset();
            obj.target.evalshape();
            loss = obj.target.eval();
            obj.target.grad(1);
            for I=1:length(obj.variables)
                v = obj.variables{I};
                obj.variables{I}.increment(-obj.learning_rate * v.xgrad);
            end
        
        end
    end
   
    
end

