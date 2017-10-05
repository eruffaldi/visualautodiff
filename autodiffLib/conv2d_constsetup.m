function [Sel_PKC_IC,Zero_Ph_Pw] = conv2d_constsetup(phase,inshape,intype,name,inputs,outputs,padding,stride)


switch(phase)
    case 0 % size
        if isempty(inshape{1}) || isempty(inshape{2})
            Sel_PKC_IC=[];
            Zero_Ph_Pw=[];
            return
        end
        [w,shape_BPKC,shapeP] = computeSomething(phase,inshape,padding,stride);
        Sel_PKC_IC = size(w.pickidx); % decided only after SETUP
        Zero_Ph_Pw = shapeP;
%         disp('conv2d_constsetup')
%         inshape{1}
%         inshape{2}
%         Sel_PKC_IC
%         Zero_Ph_Pw
    case 1 % type
        Sel_PKC_IC = int32(0);
        Zero_Ph_Pw = false(0);
    case 2 % value
        [w,shape_BPKC,shapeP] = computeSomething(phase,inshape,padding,stride);
        Sel_PKC_IC = w.pickidx;
        Zero_Ph_Pw = false(shapeP);
        % no need to emit Zero_Ph_Pw
end


function [w,shape_BPKC,shapeP] = computeSomething(phase,inshape,padding,stride)
    
xla = inshape{1};
xra = inshape{2};

            if isempty(xla)
                %disp(sprintf('conv2d_setup(%d): %s no input',state,gcb));
                w = [];
                shape_BPKC = [];
                shapeP = [];
                return;
            end
            xl = ones(1,4);
            xl(1:numel(xla)) = xla;
            xr = ones(1,4);
            xr(1:numel(xra)) = xra;

            % Fh Fw Fi Fo
            h_filter = xr(1); 
            w_filter = xr(2);
            stride1 = stride(1);
            [padding,sizeout,offsetout] = paddingsetup([xl(2) xl(3)],[h_filter,w_filter],stride(2:3),padding);


            % Input:  B Ih Iw C
            % Output: B Ph Pw C
            % Patch Representation: B Ph Pw Kh Kw C
            %   the product is against: W as  [Kh Kw C Q]
            %   and we work in 2D: (B Ph Pw) (Kh Kw C) by (Kh Kw C) (Q)
            [w,shape_BPKC,shapeP] = mpatchprepare(xl,[h_filter w_filter],sizeout,[stride1 stride1],padding, 'BPKC'); % N independent

            %disp(sprintf('conv2d_setup(%d): %s input shapeP',state,gcb));
            %disp(xla)
            %disp(shapeP)