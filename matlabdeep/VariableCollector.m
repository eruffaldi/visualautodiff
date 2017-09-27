classdef VariableCollector < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        collected
        icollected
    end
    
    methods
         function obj = VariableCollector()
             v = Variable('dummy',0);
             obj.collected = cell(100,1); % max
             for i=1:length(obj.collected)
                 obj.collected{i} = v;
             end
             obj.icollected = 0;
         end
         
         function r = collect(obj,op)
             op.visit(@(x) obj.callback(x));
             if obj.icollected == 0
                 r = {};
                 return;
             end
             
             % TODO: now that we have ids we can extract them and use
             % unique
             
             % compute unique set of variable: N^2 
             equality = zeros(obj.icollected);
             for I=1:obj.icollected
                 for J=I+1:obj.icollected
                     equality(I,J) = obj.collected{I}.xid == obj.collected{J}.xid;
                 end
             end
             %modified for codegeneration
             available = 1:obj.icollected;
             selected = zeros(obj.icollected,1);   % to avoid growth           
             k = 0;
             while ~isempty(available)
                 cur = available(1);
                 k = k + 1;
                 selected(k) = cur;
                 % remove all the ones equal to current
                 available = setdiff(available(2:end),find(equality(cur,:)));
             end
             r = cell(k,1);
             for I=1:k
                r{I} = obj.collected{selected(I)};
             end
             obj.collected = r;
             % pick only the ones in selected (up to k)
             %r = obj.collected(selected(1:k));
         end
         
         function r = callback(obj,op)
             if isa(op,'Variable')
                 obj.icollected = obj.icollected+1;
                 obj.collected{obj.icollected} = op;
                 r = 0;
             else
                 r = 1;
             end
         end
         
         function r = paramcount(obj)
             if isempty (obj.collected)
                 r = 0;
             else
                 r = sum(cellfun(@(o) prod(o.xshape),obj.collected));
             end
         end
         

    end
    
    
end

