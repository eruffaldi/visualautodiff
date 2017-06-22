function x = blocklconn(name,b,q)
a = get_param([name '/' b],'PortHandles');
x = a.LConn(q);