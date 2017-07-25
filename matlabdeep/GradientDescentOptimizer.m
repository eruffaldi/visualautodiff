classdef GradientDescentOptimizer < Optimizer
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        precision
        target
    end
    
    methods 
        function obj = GradientDescentOptimizer(precision,target)
            obj = obj@Optimizer();
            obj.precision = precision;
            obj.target = target;
            target.reset();
        end
        
        % step using pairs of cell arrays
        function r = eval(obj)
           r = 0;
        end
    end
   
    
end

