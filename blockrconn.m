function x = blockrconn(name,b,q)
a = get_param([name '/' b],'PortHandles');
x = a.RConn(q);