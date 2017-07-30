% [k,i,j] = imagepad(1,[28,28],5,5,0,[2,2])
function [outshape,k,i,j] = imagepad(C,shape,field_height,field_width,padding,stride)

[p,n,e] =  fileparts(fullfile(mfilename('fullpath')));
tp = [p,filesep,'im2col.py'];
tmp = tempname;
cmd = sprintf('python \"%s\" \"%s\" %d %d %d %d %d %d %d %d %d %d %d',tp,tmp,C,shape(1),shape(2),field_height(1),field_width(1),padding(1),padding(2),padding(3),padding(4),stride(1),stride(2))
system(cmd);
%tmp
%system(['ls -l ' tmp])

fid = fopen(tmp,'r');
outshape = fread(fid,2,'uint32');
n = fread(fid,2, 'uint32')';
k = fread(fid,[n(2),n(1)],'uint32')';
n = fread(fid, 2,'uint32')';
i = fread(fid,[n(2),n(1)],'uint32')';
n = fread(fid, 2,'uint32')';
j = fread(fid,[n(2),n(1)],'uint32')';
fclose(fid);
