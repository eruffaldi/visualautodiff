function x = blocklconn(name,b)
a = get_param([name '/' b],'PortHandles');
if isempty(a.LConn)
    x = a.RConn(1);
else
    x = a.LConn(1);
end
