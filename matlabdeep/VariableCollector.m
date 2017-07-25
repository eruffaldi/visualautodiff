classdef VariableCollector < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        collected
    end
    
    methods
         function obj = VariableCollector()
             obj.collected = {};
         end
         
         function r = collect(obj,op)
             obj.collected = {};
             op.visit(@(x) obj.callback(x));
             r = obj.collected;
         end
         
         function r = callback(obj,op)
             if isa(op,'Variable')
                 obj.collected{end+1} = op;
                 r = 0;
             else
                 r = 1;
             end
         end
         

    end
    
    
end

