function fx()

agcb = 'ad_blocks/Share Value x4';
asub = agcb;
aadd = [agcb '/Add'];
atwo = [agcb '/TW%d'];
ain =  [agcb '/X%d'];
aout = [agcb, '/OUT'];
outputs = max(2,floor(eval(get_param(agcb,'outputs'))));
ai = get_param(aadd,'Inputs');

if length(ai) < outputs
    set_param(aadd,'Inputs',repmat('+',1,outputs));
    ain1 = sprintf(ain,1);
    atwo1 = sprintf(atwo,1);
    haddph = get_param(aadd,'PortHandles');
    houtph = get_param(aout,'PortHandles');
    for J=length(ai)+1:outputs
        ainJ = sprintf(ain,J);
        atwoJ = sprintf(atwo,J);
        h1 = add_block(ain1,ainJ,'CopyOption','duplicate');
        h1ph = get_param(h1,'PortHandles');        
        h2 = add_block(atwo1,atwoJ,'CopyOption','duplicate');
        h2ph = get_param(h2,'PortHandles');
        % wire: h1.o1 to h2.o2
        % wire: OUT.o1 to h2.i1
        % wire: h2.o2 to adder.iJ
        add_line(asub,h1ph.RConn(1),h2ph.RConn(1));
        add_line(asub,houtph.Outport(1),h2ph.Inport(1));
        add_line(asub,h2ph.Outport(1),haddph.Inport(J));
    end
elseif length(ai) > outputs
    set_param(aadd,'Inputs',ai(1:outputs));
    for J=outputs+1:length(ai)
        ainJ = sprintf(ain,J);
        atwoJ = sprintf(atwo,J);
        delete_block(ainJ);
        delete_block(atwoJ);
    end
    delete_line(find_system(asub,'LookUnderMasks','on', 'FindAll', 'on', 'Type', 'line', 'Connected', 'off'))
else
    % fine
end

end


%TwoWay:
