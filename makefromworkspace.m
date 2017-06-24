function s = makefromworkspace(t,d)

ss = size(d);
assert(ss(1) == numel(t),'time length == data length first dim');
s.time = t(:);
s.signals.dimensions = ss(2:end);
s.signals.values = d;
