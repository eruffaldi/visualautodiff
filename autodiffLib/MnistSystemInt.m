classdef MnistSystemInt < matlab.System  & matlab.system.mixin.Propagates
    % MnistSystem
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties(Nontunable)
        trainset = 1;
        items = 100;
        shuffle = 0;
    end


    properties(DiscreteState)
    end

    % Pre-computed constants!
    properties(Access = private)
        epoch
        lastdone
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
             obj.lastdone = 0;
             if obj.shuffle
                 obj.indices = int32(randperm(obj.n));
             else
                 obj.indices = int32(1:obj.n);
             end
         end
      
        
        function [indices] = stepImpl(obj)
           needed = obj.items;
           indices= zeros(obj.items,1,'int32'); %size(obj.allimages,2));
          writeindex = 1;
           while needed > 0
                thisstep = min(needed,obj.n-obj.lastdone);
                if thisstep == 0
                    obj.lastdone = 0;
                    obj.epoch = obj.epoch + 1;
                    if obj.shuffle
                        obj.indices = int32(randperm(obj.n));
                    else
                        obj.indices = int32(1:obj.n);
                    end
                    thisstep = min(needed,obj.n-obj.lastdone);
                end
                if thisstep > 0
                    indices(writeindex:writeindex+thisstep-1,:) = obj.indices(obj.lastdone+1:obj.lastdone+thisstep);
                    obj.lastdone = obj.lastdone + thisstep;
                    writeindex = writeindex + thisstep;
                    needed = needed - thisstep;
                end
           end
        end

       
    end
end
