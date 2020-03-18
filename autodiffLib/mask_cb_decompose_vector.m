function fx()

agcb = 'ad_blocks/vector decompose';
asub = agcb;
aindex =[agcb '/index'];
abias = [agcb '/B%d'];
asel = [agcb '/S%d'];
aout =  [agcb '/OUT%d'];
ain = [agcb '/SH'];
outputs = max(2,floor(eval(get_param(agcb,'outputs'))));
ai = eval(get_param(ain,'outputs'));

if ai < outputs
    set_param(ain,'outputs',num2str(outputs));
    abias2 = sprintf(abias,2); % bias 1 is missing
    asel1 = sprintf(asel,1);
    aout1 = sprintf(aout,1);
    hindexph = get_param(aindex,'PortHandles');
    hinph = get_param(ain,'PortHandles');
    for J=ai+1:outputs
        abiasJ = sprintf(abias,J);
        aselJ = sprintf(asel,J);
        aoutJ = sprintf(aout,J);
        
        hbias = add_block(abias2,abiasJ,'CopyOption','duplicate');
        set_param(hbias,'Bias',num2str(J-1));
        hbiasph = get_param(hbias,'PortHandles');        

        hsel = add_block(asel1,aselJ,'CopyOption','duplicate');
        hselph = get_param(hsel,'PortHandles');        

        hout = add_block(aout1,aoutJ,'CopyOption','duplicate');
        houtph = get_param(hout,'PortHandles');        

        % 
        add_line(asub,hinph.RConn(J),hselph.LConn(1));
        add_line(asub,hselph.RConn(1),houtph.RConn(1));
        add_line(asub,hindexph.Outport(1),hbiasph.Inport(1));
        add_line(asub,hbiasph.Outport(1),hselph.Inport(1));
    end
elseif ai > outputs
    set_param(ain,'outputs',num2str(outputs));
    for J=outputs+1:ai
        abiasJ = sprintf(abias,J);
        aselJ = sprintf(asel,J);
        aoutJ = sprintf(aout,J);
        delete_block(aselJ);
        delete_block(abiasJ);
        delete_block(aoutJ);
    end
    delete_line(find_system(asub,'LookUnderMasks','on', 'FindAll', 'on', 'Type', 'line', 'Connected', 'off'))
else
    % fine
end

end


%TwoWay:
