#https://stackoverflow.com/questions/37799906/makefile-to-compile-multiple-mex-functions

extra="COMPFLAGS=-march=native -O2 -DNDEBUG"

mex="/Applications/MATLAB_R2017b.app/bin/mex"
suffix=.mexmaci64

all: accumgather.dylib  sfun_superconst$(suffix) accummatrix_cm$(suffix) accummatrix_rm$(suffix) gathermatrix_cm$(suffix) gathermatrix_rm$(suffix)
#fromjson$(suffix)
accumgather.dylib: accumgather.c
	gcc --shared $< 
   
accummatrix_cm$(suffix): accummatrix_cm.cpp
	${mex} $< $(extra)
    
accummatrix_rm$(suffix): accummatrix_rm.cpp
	${mex} $< $(extra)
    
gathermatrix_cm$(suffix): gathermatrix_cm.cpp
	${mex} $< $(extra)
    
gathermatrix_rm$(suffix): gathermatrix_rm.cpp
	${mex} $< $(extra)
    
sfun_superconst$(suffix): sfun_superconst.c
	${mex} $< $(extra)
    
fromjson$(suffix): fromjson.c
	${mex} $< $(extra)