%Measures the probability error in discrete classification tasks in which the classes are mutually exclusive (each entry is in exactly one class). For example, each CIFAR-10 image is labeled with one and only one label: an image can be a dog or a truck, but not both.
classdef MnistBatcher < handle
    
    properties
        epoch
        last
        alllabels
        allimages
        alllabelshot
        n
        indices
        shuffle
        colmajor
    end
    

    methods
        function obj = MnistBatcher(content,shuffle)
                
            if nargin < 2
                shuffle = 1;
            end
            obj.colmajor = 1;
            obj.shuffle = shuffle;
             obj.epoch = 1;
             obj.last = 0;
             if strcmp(content,'train')
                 if obj.colmajor
                    Trimages = loadMNISTImages('train-images.idx3-ubyte',1);
                    Trlabels = loadMNISTLabels('train-labels.idx1-ubyte')';
                    Trlabelshot = onehot(Trlabels,0,9)'; %full(ind2vec((Trlabels+1)))';
                assert(size(Trlabels,1) == 1);
                 else
                    Trimages = loadMNISTImages('train-images.idx3-ubyte');
                    Trlabels = loadMNISTLabels('train-labels.idx1-ubyte')';
                Trlabelshot = onehot(Trlabels,0,9); %full(ind2vec((Trlabels+1)))';
                assert(size(Trlabels,1) == 2);
                 end
                %Trimagesx = makefromworkspace(1:length(Trimages),Trimages);
                %Trlabelshotsx = makefromworkspace(1:length(Trlabelshot),Trlabelshot')
                obj.alllabels = Trlabels;                
                obj.alllabelshot = Trlabelshot;
                obj.allimages = Trimages;
             else
                 if obj.colmajor
                    Teimages = loadMNISTImages('t10k-images.idx3-ubyte',1);
                    Telabels = loadMNISTLabels('t10k-labels.idx1-ubyte')';
                    Telabelshot = onehot(Telabels,0,9)'; % full(ind2vec((Telabels+1)))';
                 else
                    Teimages = loadMNISTImages('t10k-images.idx3-ubyte',0);
                    Telabels = loadMNISTLabels('t10k-labels.idx1-ubyte')';
                    Telabelshot = onehot(Telabels,0,9); % full(ind2vec((Telabels+1)))';
                 end
                 
                obj.alllabels = Telabels;                
                obj.alllabelshot = Telabelshot;
                obj.allimages = Teimages;
             end
             obj.n = length(obj.alllabels);
             if obj.shuffle
             obj.indices = randperm(obj.n);
             else
                 obj.indices = 1:obj.n;
             end
        end
        
        function [i,l,lh,li] = next(obj,items)
            left = min(items,obj.n-obj.last);
            if left > 0
                Q = obj.indices(obj.last+1:obj.last+left);
                if obj.colmajor
                    i = obj.allimages(:,Q);
                    l = obj.alllabels(Q);
                    lh = obj.alllabelshot(:,Q);
                    li = Q;
                else
                    i = obj.allimages(Q,:);
                    l = obj.alllabels(Q,:);
                    lh = obj.alllabelshot(Q,:);
                    li = Q;
                end
                obj.last = obj.last + left;
            else
                i = [];
                l = [];
                lh = [];
                li = [];
            end               
            if left < items
                % new epoch reshuffle and recurse
                obj.last = 0;
                obj.epoch = obj.epoch + 1;   
                if obj.shuffle
                    obj.indices = randperm(obj.n);
                else
                    obj.indices = 1:obj.n;
                end
                [ti,tl,tlh,tli] = obj.next(items-left);
                if obj.colmajor
                    i = [i,ti];                    
                        l = [l,tl];
                    lh = [lh,tlh];
                    li = [li,tli];
                else
                    i = [i;ti];
                    l = [l,tl];
                    lh = [lh;tlh];
                    li = [li;tli];
                end
            end            
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

