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
             if isempty(obj.collected)
                 r = {};
                 return;
             end
             % compute unique set of variable: N^2 
             equality = zeros(length(obj.collected));
             for I=1:length(obj.collected)
                 for J=I+1:length(obj.collected)
                     equality(I,J) = obj.collected{I} == obj.collected{J};
                 end
             end
             available = 1:length(obj.collected);
             selected = [];             
             while ~isempty(available)
                 cur = available(1);
                 selected(end+1) = cur;
                 % remove all the ones equal to current
                 available = setdiff(available(2:end),find(equality(cur,:)));
             end
             r = obj.collected(selected);
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

