function Xp = mpatcher(X,Sel,sXp,colmajor)

if colmajor
     Xp = mpatcher_cm(X,Sel,sXp);
else
     Xp = mpatcher_rm(X,Sel,sXp);
end    