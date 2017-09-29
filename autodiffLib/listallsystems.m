%get_param(gcb,'BlockType')
%a = get_param(gcb,'DialogParameters')
%a.SimulateUsing
%get_param(gcb,'SimulateUsing')
%'Code generation'  'Interpreted execution'}
allsys = find_system('LookUnderMasks','all','BlockType','MATLABSystem');
allvideo = {};
recolor = 1;
for I=1:length(allsys)
    try
    using = get_param(allsys{I},'SimulateUsing');
    catch me
        continue
    end
    if strcmp(using,'Interpreted execution')
        allvideo{end+1} = allsys{I};
        set_param(allsys{I},'BackgroundColor','orange')
    else
        set_param(allsys{I},'BackgroundColor','white')
    end
end
allvideo'


