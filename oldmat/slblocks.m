function blkStruct = slblocks
		% This function specifies that the library should appear
		% in the Library Browser
		% and be cached in the browser repository

		Browser.Library = 'autodiff';
		% 'mylib' is the name of the library

		Browser.Name = 'AutoDiff';
		% 'My Library' is the library name that appears in the Library Browser
        %Browser.IsFlat  = 1;
        blkStruct.Browser = Browser; 
		