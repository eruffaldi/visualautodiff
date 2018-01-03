classdef TargetSpec
    properties
        fullshape
        partshape
        mode 
        
        scalarindex % for mode = 1
        rangeindex  % for mode = 2
        indices     % for mode = 3
    end
    
    methods (Static)
        % fullShape is the output tensor shape
        % indices is a vector of same size of fullShape with the indices
        function obj = makeScalar(fullshape,indices)
            obj.mode = 1;
            obj.fullshape = fullshape;
            obj.partshape = ones(length(fullshape),1);
            obj.scalarindex = indices;
            assert(length(fullshape) == length(indices),'same as indices and shape');
            assert(all(arrayfun(@(i) indices(i) >= 1 & indices(i) <= fullshape(i),1:length(fullshape))),'valid interval');
        end

        % make convex mode along all shape
        function obj = makeFull(fullshape)
            % scalar shape
            if length(fullshape) == 1 && fullShape(1) == 1
                obj.mode = 1;
                obj.fullshape = fullshape;
                obj.partshape = 1;
                obj.scalarindex = 1;
            else
                % full range
                obj.mode = 2;
                obj.fullshape = fullshape;
                obj.partshape = fullshape;
                obj.rangeindex = [ones(length(fullshape),1), fullshape(:)];
            end
        end

        function obj = makeConvex(fullshape,intervals)
            assert(size(intervals,1) == length(fullshape),'intervals rows are dimensions');
            assert(size(intervals,2) == 2,'intervals cols are start:end inclusive 1-based');
            assert(all(intervals(:,1) <= intervals(:,2)),'start <= end');
            assert(all(intervals(:,1) >= 1),'start at least 1');
            assert(all(intervals(:,2) <= fullshape),'range validity');
            obj.mode = 2;
            obj.fullshape = fullshape;
            obj.partshape = intervals(:,2)-intervals(:,1)+1;
            obj.rangeindex = intervals;
        end

        % absolute indices as in sub2ind
        function obj = makeIndices(fullshape,indices)
            obj.mode = 3;
            obj.fullshape = fullshape;
            obj.partshape= size(indices);
            obj.indices = indices;   
            nm = prod(fullshape);
            % first same number of dimensions (eventually squeezed)
            assert(length(obj.partshape) == length(obj.fullshape),'same dimensions');
            % correct size
            assert(all(obj.partshape(:) <= obj.fullshape(:)),'valid interval');
            % and not empty sizes
            assert(all(obj.partshape(:) >= 1),'non empty interval');
            % indices valid
            assert(all(indices(:) >= 1));
            assert(all(indices(:) <= nm));
        end
    end
    
    methods
        function obj = TargetSpec()
            obj.mode = 0; % wrong
        end
        
        function s = isscalar(obj)
            s = obj.mode == 1;
        end

        function s = isconvex(obj)
            s = obj.mode == 2;
        end
        
        function s = isindices(obj)
            s = obj.mode == 3;
        end
        
        % conversion from one mode to another
    end
end
