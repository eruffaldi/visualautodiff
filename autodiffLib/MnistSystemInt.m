classdef MnistSystemInt < matlab.System  & matlab.system.mixin.Propagates
    % MnistSystem
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties(Nontunable)
        trainset = 1;
        items = 100;
    end


    properties(DiscreteState)
    end

    % Pre-computed constants!
    properties(Access = private)
        epoch
        iteration
        n
        indices
    end

    methods(Access = protected)
        function setupImpl(obj)
            if obj.trainset
                obj.n = 60000;
            else
                obj.n = 10000;
            end
        end

        function  [p1] = isOutputFixedSizeImpl(obj)
            p1 = true;
         
        end

        
        
            function [p1] = getOutputDataTypeImpl(obj)
                p1 = 'int32';
            end
            
            function [p1] = isOutputComplexImpl(obj)
                p1 = false;
            end
            
        function [sz_1] = getOutputSizeImpl(obj) 
            
              sz_1 = [obj.items,1];
        end
        
         function resetImpl(obj)
           % Perform one-time calculations, such as computing constants
             obj.epoch = 1;
             obj.iteration = 1;
             obj.indices = int32(randperm(obj.n));
         end
      
        
        function [indices] = stepImpl(obj)
           needed = obj.items;
           indices= zeros(obj.items,1,'int32'); %size(obj.allimages,2));
           k1 = 1;
           while needed > 0
                left = min(needed,obj.n-obj.iteration);
                if left == 0
                    obj.iteration = 1;
                    obj.epoch = obj.epoch + 1;                
                    obj.indices = int32(randperm(obj.n));
                    left = min(needed,obj.n-obj.iteration);
                end
                if left > 0
                    indices(k1:k1+left-1,:) = obj.indices(obj.iteration:obj.iteration+left-1);
                    obj.iteration = obj.iteration + left;
                    k1 = k1 + left;
                    needed = needed - left;
                end
           end
        end

       
    end
end
