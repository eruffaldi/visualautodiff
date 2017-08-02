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
        inited
    end

    % Pre-computed constants!
    properties(Access = private)
        epoch
        iteration
        alllabels
        allimages
        alllabelshot
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
            obj.alllabels = zeros(obj.n,1);
            obj.alllabelshot = zeros(obj.n,10);
            obj.allimages = zeros(obj.n,784);    
            obj.inited = 0;
        end

        function  [p1,p2,p3,out4] = isOutputFixedSizeImpl(obj)
            p1 = true;
            p2= true;
            p3 =true;
         
        end

        function [sz,dt,cp] = getDiscreteStateSpecificationImpl(obj,name)
            % Return size, data type, and complexity of discrete-state
            % specified in name
            sz = [1 1];
            dt = 'double';
            cp = false;
        end
        
        
        
            function [p1,p2,p3,out4] = getOutputDataTypeImpl(obj)
                p1 = 'double';
                p2 = 'double';
                p3 = 'double';
            end
            
            function [p1,p2,p3,out4] = isOutputComplexImpl(obj)
                p1 = false;
                p2 = false;
                p3 = false;
            end
            
        function [sz_1,sz_2,sz_3,out4] = getOutputSizeImpl(obj) 
            
              sz_1 = [obj.items,28*28];
              sz_2 = [obj.items,1];
              sz_3 = [obj.items,10];
        end
        
         function resetImpl(obj)
           % Perform one-time calculations, such as computing constants
             obj.epoch = 1;
             obj.iteration = 1;
             obj.indices = randperm(obj.n);
         end
      
        
        function [x,labels,labelshot] = stepImpl(obj,inimages,inlabels,inlabelshot)
            if obj.inited == 0
                obj.inited = 1;
                obj.alllabels = double(inlabels);
                obj.alllabelshot = double(inlabelshot);
                obj.allimages = (double(inimages)/255.0);
            end
           needed = obj.items;
           x = zeros(obj.items,28*28); %size(obj.allimages,2));
           labels = zeros(obj.items,1);
           labelshot = zeros(obj.items,10);
           k1 = 1;
           while needed > 0
                left = min(needed,obj.n-obj.iteration);
                if left == 0
                    obj.iteration = 1;
                    obj.epoch = obj.epoch + 1;                
                    obj.indices = randperm(obj.n);
                    left = min(needed,obj.n-obj.iteration);
                end
                if left > 0
                    Q = obj.indices(obj.iteration:obj.iteration+left-1);
                    x(k1:k1+left-1,:) = obj.allimages(Q,:);
                    labels(k1:k1+left-1,:) = obj.alllabels(Q,:);
                    labelshot(k1:k1+left-1,:) = obj.alllabelshot(Q,:);
                    obj.iteration = obj.iteration + left;
                    k1 = k1 + left;
                    needed = needed - left;
                end
           end
        end

       
    end
end
