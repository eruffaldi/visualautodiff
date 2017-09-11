classdef train_test_mgr < matlab.System
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
    properties
        testsize=0
        trainsize=0
        skiptrain=0
        epochs=100
        batchsize=100
    end

    properties(DiscreteState)
        step
        iteration
        lastdotrain
    end

    % States: Constant
    %                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          12
    properties(Access = private)        
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
            obj.step = 0;
            obj.iteration = double(0);
            obj.lastdotrain = double(-1);
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
            t = obj.step;
            obj.step = obj.step + 1;
            instop = t >= obj.stoptime;
            dotrain = double(t >= obj.trainrange(1) & t < obj.trainrange(2));
            if dotrain == 1
                samples = obj.trainsize;
            else
                samples = obj.testsize;
            end
            if obj.lastdotrain ~= (dotrain)
                % new state => first iteration, update last and emit new
                % epoch
                obj.iteration = 1;
                obj.lastdotrain = (dotrain);    
                newepoch = true;
            else
                newepoch = mod(obj.iteration,obj.iterperepoch) == 0;
            end
            iteration = obj.iteration;
            obj.iteration = obj.iteration +1;
            %intest = t >= obj.testrange(1) & t < obj.testrange(2);
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
            obj.step = 0;
            obj.iteration = 1;
            obj.lastdotrain = -1;
        end
    end
end
