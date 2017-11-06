% Reverses the input data from patches aggregating
%
% Xp = input patches = [N x P]
% Sel = selector = [P x Q]
%
% Output
%   X = [N x Q]
%
% Where
%   Q = input space
function X = munpatcher(Xp,Sel,NHWCshape,SelA)

nB = NHWCshape(1);
Ih = NHWCshape(2);
Iw = NHWCshape(3);
if length(NHWCshape) == 3
    nC = 1;
else
    nC = NHWCshape(4);
end

Xpm = reshape(Xp,nB,[]); % keep on the left

%sparse Approach => no GPU, only double
%w = double(Xpm)*Sel.A;
oshape = [nB,Ih,Iw,nC];
%accumarray Approach: notpossibly because value is vector => loops
%w = accumarray(Sel.kq,Xpm,[size(Xpm,1),size(Sel.A,2)]);
if isa(Xpm,'gpuArray')
    w = accummatrix_rm(Sel.pickidx,gather(Xpm),SelA); %size(Sel.A,2));
else
    if isstruct(Sel)
        % ALWAYS MATLAB path
        f = Sel.accum;
        w = f(Sel.pickidx,Xpm,SelA); %size(Sel.A,2));
    else 
        if coder.target('MATLAB')
            % MEX
            % also interpreted mode MATLAB System Blocks
            w = accummatrix_rm(Sel,Xpm,SelA);
        elseif  coder.target('Rtw') % false && (coder.target('Sfun') ||
            % CODEGEN typed
            % also code gen MATLAB System Blocks
            w = coder.nullcopy(zeros(oshape,'like',Xpm));
            
            % REMEMBER: set_param(gcs, 'SupportModelReferenceSimTargetCustomCode', 'on');

            % TODO
            % void accummatrix_float(const float * pdata,int rows,int cols,const int32_t * psubs,int nsubs,float * pout,int outcols);
            rows = int32(size(Xpm,1));
            cols = int32(size(Xpm,2));
            nsubs = int32(numel(Sel));
            
            outcols = int32(SelA);
            % ORIGINAL: accummatrix(S=subs_of_col,A=val_matrix,n=size_out_cols)
            coder.ceval(['accummatrix_rm_' class(w)],coder.rref(Xpm),rows,cols,coder.rref(Sel),nsubs,coder.wref(w),outcols);
        else
            % SLOW fallback
            w = accummatrixmat_rm(Sel,Xpm,SelA);
        end
    end
        
end

X = reshape(w,oshape); % product is Nx(Ih Iw C)

if isa(Xpm,'gpuArray')
    X =  cast(X,'like',Xpm);
end
