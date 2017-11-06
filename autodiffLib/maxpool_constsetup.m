function [Sel_IC_KCP,argmaxbase,argmaxbasescale,Zero_Ph_Pw,Sel_IC_KCP_A] = maxpool_constsetup(phase,inshape,intype,name,inputs,outputs,ksize,stride,padding)


switch(phase)
    case 0 % size
        if isempty(inshape{1})
            Sel_IC_KCP=[];
            argmaxbase=[];
            argmaxbasescale=[];
            Zero_Ph_Pw=[];
            Sel_IC_KCP_A=[];
            return
        end
            [w,shape_K_CPB,shapeP,wa] = computeSomething(phase,inshape,ksize,stride,padding);
            
            Sel_IC_KCP = size(w); % decided only after SETUP
            Sel_IC_KCP_A = 1; %size(wa);
            Zero_Ph_Pw = shapeP;
            [ab,abs] = argmax_to_max_setup(shape_K_CPB,2); 
            argmaxbasescale = size(abs);
            argmaxbase =size(ab);

    case 1 % type
        Sel_IC_KCP = int32(0);
        Zero_Ph_Pw = false(0);
        Sel_IC_KCP_A = int32(0);
        argmaxbase=int32(0);
        argmaxbasescale=int32(0);
    case 2 % value
        [Sel_IC_KCP,shape_K_CPB,shapeP,Sel_IC_KCP_A] = computeSomething(phase,inshape,ksize,stride,padding);
        [objargmaxbase,objargmaxbasescale] = argmax_to_max_setup(shape_K_CPB,2); 
        argmaxbase = cast(objargmaxbase,'int32');
        argmaxbasescale = cast(objargmaxbasescale,'int32');
        Zero_Ph_Pw = false(shapeP);
        
end

function [Sel_IC_KCP,shape_K_CPB,shapeP,Sel_IC_KCP_A] = computeSomething(phase,inshape,ksize,strides,padding)
            assert(numel(ksize) == 4);
            assert(ksize(1) == 1 & ksize(4) == 1);
            assert(strides(1) == 1 & strides(4) == 1);
            
            xla = inshape{1};
%             if isempty(xla)
%                 %disp(sprintf('maxpool_setup(%d): %s no input',state,gcb));
%                 w = [];
%                 Sel_IC_KCP = [];
%                 shape_K_CPB = [];
%                 shapeP = [];
%                 return;
%             end
            
            xl = ones(1,4);
            xl(1:length(xla)) = xla;
            nC = xl(4);
            nB = xl(1);

            % General case
            h_filter = ksize(2);
            w_filter = ksize(3);
            
            [padding,sizeout,offsetout] = paddingsetup([xl(2) xl(3)],[h_filter,w_filter],strides(2:3),padding);
            % Input:  B Ih Iw C
            % Output: B Ph Pw C
            % Patch Representation: B Ph Pw C Kh Kw
            %   the max reduction is over the last two dimensions
            %   obtaining: B Ph Pw C
            [w,~,shapeP] = mpatchprepare(xl,[h_filter w_filter],sizeout,[strides(2) strides(3)],padding,'KCPB'); % N independent
            r = [nC shapeP(1) shapeP(2) nB]; % output BPC
            
            %disp(sprintf('maxpool_setup(%d): %s input shapeP and padding:',state,gcb));
            %disp(xl);
            %disp(shapeP)
            %disp(padding);
            
            %obj.xshape = r;            
            Sel_IC_KCP_A = int32(1);
            Sel_IC_KCP = w.pickidx;
            
            shape_K_CPB = [h_filter*w_filter prod(r) ]; % patches for max: BPC K
            
