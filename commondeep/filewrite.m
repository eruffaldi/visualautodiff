function filewrite(name,txt)

fp = fopen(name,'wt');
fwrite(fp,txt);
fclose(fp);
end
