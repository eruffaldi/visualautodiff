classdef AdamOptimizer < Optimizer
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        precision
        target
        variables
    end
    
    methods 
        function obj = AdamOptimizer(precision,target)
            obj = obj@Optimizer();
            obj.precision = precision;
            obj.target = target;
            obj.variables = VariableCollector().collect(target);
            target.reset();
        end
        
        % step using pairs of cell arrays
        function r = eval(obj)
            r = 0;
        end
    end
   
    
end

