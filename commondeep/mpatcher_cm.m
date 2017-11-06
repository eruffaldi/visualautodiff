% makes patches using sparse matrix
%
% X = input data unpatched
% Sel = sparse matrix Q x P
% sXp = output shape as provided by mpatchprepare
% 
% Output: Xp patches
function Xp = mpatcher(X,Sel,sXp)

nB = size(X,1);
%sXp(1) = sXp(1)*nB;  % removed
% sel: [ H W C, P F C]
% as:  [ N H W C ]
% Xp:  [ N P F C ]
as = reshape(X,nB,[]); % [nB , Ih Iw C]

%sparse Approach: only double and optimizable
%w = double(as)*Sel.A';
if isa(as,'gpuArray')
    w = gathermatrix_cm(Sel.pickidx,gather(as),length(Sel.pickidx));
else
    if isstruct(Sel)
        % ALWAYS MATLAB path
        f = Sel.gather;
        w = f(Sel.pickidx,as,length(Sel.pickidx));
    else
        if coder.target('MATLAB')
            % MEX
            % MATLAB intepreted and MATLAB System Blocks
            w = gathermatrix_cm(Sel,as,length(Sel));
        elseif   coder.target('Rtw') % false && (coder.target('Sfun') ||
            % codegen MATLAB System Blocks
            w = coder.nullcopy(zeros(sXp,'like',as)); % uninited
%TODO            void gathermatrix_float(const float * pdata,int rows,int cols,const int32_t * psubs,int nsubs,float * pout,int outcols);
            rows = int32(size(as,1));
            cols = int32(size(as,2));
            nsubs = int32(numel(Sel));
            outcols = int32(length(Sel));
            % gathermatrix(S=subs_of_col,A=val_matrix,n=size_out_cols)
            
            coder.ceval(['gathermatrix_cm_' class(w)],coder.rref(as),rows,cols,coder.rref(Sel),nsubs,coder.wref(as),outcols); % c version
        else
            % slow fallback
            w = gathermatrixmat_cm(Sel,as,length(Sel));            
        end
    end
end
Xp = reshape(w,sXp); % [nB , P, F, C]
if isa(as,'gpuArray')    
    Xp =  cast(Xp,'like',as);
end
