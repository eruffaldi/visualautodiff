function X = munpatcher(Xp,Sel,NHWCshape,SelA,colmajor)

if colmajor
    X = munpatcher_cm(Xp,Sel,NHWCshape,SelA);
else
    X = munpatcher_rm(Xp,Sel,NHWCshape,SelA);
end    