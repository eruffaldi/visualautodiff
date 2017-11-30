function [changed,total]=set_system_codemode(target,codemode)
%get_param(gcb,'BlockType')
%a = get_param(gcb,'DialogParameters')
%a.SimulateUsing
%get_param(gcb,'SimulateUsing')
%'Code generation'  'Interpreted execution'}
if isempty(target)
    allsys = find_system('FollowLinks','on','LookUnderMasks','all','BlockType','MATLABSystem');
else
    allsys = find_system(target,'FollowLinks','on','LookUnderMasks','all','BlockType','MATLABSystem');
end
total=length(allsys)
            changed=0;
allvideo = {};
recolor = 1;
for I=1:length(allsys)
    try
    using = get_param(allsys{I},'SimulateUsing');
    catch me
        continue
    end
    if strcmp(using,'Interpreted execution')
        if codemode ~= 0
            set_param(allsys{I},'SimulateUsing','Code generation');
            changed=changed+1;
        end
    else
        if codemode == 0
            set_param(allsys{I},'SimulateUsing','Interpreted execution');
            changed=changed+1;
        end
    end
end
            


