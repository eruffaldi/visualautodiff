classdef train_test_mgr < matlab.System& matlab.system.mixin.Propagates 
    % train_test_mgr    Controls the current task in a Simulation acting as
    % training and testing
    %
    % Actions:
    %   Training Phase
    %   Testing Phase
    %   Stop
    % 
    % Parameters Storage:
    %   we need to support 
    
    % Public, tunable properties
    properties(Nontunable)
        testsize=0
        trainsize=0
        skiptrain=0
        epochs=100
        batchsize=100
    end

    properties(DiscreteState)
        stStep
        stIteration 
        stLastdotrain 
    end

    % States: Constant
    %                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          12
    properties(Nontunable,Access = private)        
        trainrange = [0,0];
        testrange= [0,0];
        stoptime = 0;
        iterperepoch = 0;
    end

    methods(Access = protected)
        function setupImpl(obj)
            % Full:
            % train
            % test
            % stop
            %
            % Test:
            % test
            % stop
            obj.stStep = 0;
            obj.stIteration = double(0);
            obj.stLastdotrain = double(-1);
            if obj.trainsize == 0 || obj.skiptrain
                obj.trainrange = [-1,-1];
                next = 0;
            else
                obj.iterperepoch =ceil(obj.trainsize/obj.batchsize);
                k = obj.epochs*obj.iterperepoch;
                obj.trainrange = [0,k]; 
                next = k;
            end
            if obj.testsize ~= 0
                k = ceil(obj.testsize/obj.batchsize);
                obj.testrange = [next,next+k];
                next = next+k;
            else
                obj.testrange = [-1,-1];
            end
            obj.stoptime = next;
        end
                 

        function [dotrain,instop,samples,iteration,newepoch] = stepImpl(obj)
            % t = ssGetT(SS)
            t = obj.stStep;
            obj.stStep = obj.stStep + 1;
            instop = t >= obj.stoptime;
            dotrain = double(t >= obj.trainrange(1) & t < obj.trainrange(2));
            if dotrain == 1
                samples = obj.trainsize;
            else
                samples = obj.testsize;
            end
            if obj.stLastdotrain ~= (dotrain)
                % new state => first iteration, update last and emit new
                % epoch
                obj.stIteration = 1;
                obj.stLastdotrain = (dotrain);    
                newepoch = true;
            else
                newepoch = mod(obj.stIteration,obj.iterperepoch) == 0;
            end
            iteration = obj.stIteration;
            obj.stIteration = obj.stIteration +1;
            %intest = t >= obj.testrange(1) & t < obj.testrange(2);
        end

        function [p1,p2,p3,p4,p5]= isOutputFixedSizeImpl(obj)
            p1 = true;
            p2 = true;
            p3 = true;
            p4 = true;
            p5 = true;
        end
        function [sz,dt,cp] = getDiscreteStateSpecificationImpl(obj,propertyname)
            sz = 1;
            dt = 'double';
            cp = false;
        end
        function [p1,p2,p3,p4,p5] = getOutputDataTypeImpl(obj)
            p1 = 'double';
            p2 = 'logical';
            p3 = 'double';
            p4 = 'double';
            p5 = 'logical';
        end
        function [p1,p2,p3,p4,p5] = getOutputSizeImpl(obj)
            p1 = 1;
            p2 = 1;
            p3 = 1;
            p4 = 1;
            p5 = 1;
        end
        function [p1,p2,p3,p4,p5] = isOutputComplexImpl(obj)
            p1 = false;
            p2 = false;
            p3 = false;
            p4 = false;
            p5 = false;
        end        
        
        function resetImpl(obj)
            % Initialize / reset discrete-state properties
            obj.stStep = 0;
            obj.stIteration = 1;
            obj.stLastdotrain = -1;
        end
    end
end
