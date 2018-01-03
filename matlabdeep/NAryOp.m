classdef NAryOp < DeepOp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        children
    end
    
    methods
        function obj = NAryOp(varargin)
            obj = obj@DeepOp();
            obj.children = varargin;
            assert(all(cellfun(@(x) isa(x,'DeepOp'),obj.children)),'all DeepOp in NAryOp');
        end

         function visit(obj,fx)
             if fx(obj) == 0
                 return;
             end
             cellfun(@(x) x.visit(fx),obj.children);
         end
       
         function reset(obj)
             cellfun(@(x) x.reset(),obj.children);
         end

    end
    
end

