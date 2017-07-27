%Measures the probability error in discrete classification tasks in which the classes are mutually exclusive (each entry is in exactly one class). For example, each CIFAR-10 image is labeled with one and only one label: an image can be a dog or a truck, but not both.
classdef MnistBatcher < handle
    
    properties
        epoch
        iteration
        alllabels
        allimages
        alllabelshot
        n
    end
    

    methods
        function obj = MnistBatcher(content)
                
             obj.epoch = 1;
             obj.iteration = 1;
             if strcmp(content,'train')
                 Trimages = loadMNISTImages('train-images-idx3-ubyte')';
                Trlabels = loadMNISTLabels('train-labels-idx1-ubyte')';
                Trlabelshot = full(ind2vec((Trlabels+1)));
                %Trimagesx = makefromworkspace(1:length(Trimages),Trimages);
                %Trlabelshotsx = makefromworkspace(1:length(Trlabelshot),Trlabelshot')
                obj.alllabels = Trlabels';                
                obj.alllabelshot = Trlabelshot';
                obj.allimages = Trimages;
             else
                Teimages = loadMNISTImages('t10k-images-idx3-ubyte')';
                Telabels = loadMNISTLabels('t10k-labels-idx1-ubyte')';
                Telabelshot = full(ind2vec((Telabels+1)));
                obj.alllabels = Telabels';                
                obj.alllabelshot = Telabelshot';
                obj.allimages = Teimages;
             end
             obj.n = size(obj.alllabels,1);
        end
        
        function [i,l,lh] = next(obj,items)
            left = min(items,obj.n-obj.iteration);
            if left == 0
                obj.iteration = 1;
                obj.epoch = obj.epoch + 1;
                left = min(items,obj.n);
            end
            i = obj.allimages(obj.iteration:obj.iteration+left-1,:);
            l = obj.alllabels(obj.iteration:obj.iteration+left-1,:);
            lh = obj.alllabelshot(obj.iteration:obj.iteration+left-1,:);
            obj.iteration = obj.iteration + left;
        end   
        
        function [i,l, lh] = whole(obj)
            i = obj.allimages;
            l = obj.alllabels;
            lh = obj.alllabelshot;
        end
        
        function r = stat(obj)
            r = [obj.epoch,obj.iteration];
        end
    end
    
end

