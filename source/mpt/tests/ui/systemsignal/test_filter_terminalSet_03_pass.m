function test_filter_terminalSet_03_pass
% copying before setting does not work (issue #105)

s = SystemSignal(1);
s.setKind('x');
s.with('terminalSet');
q = s.copy(); % must work
q.terminalSet = Polyhedron('lb', -1, 'ub', 1);
assert(isempty(s.terminalSet));
s.terminalSet = Polyhedron('lb', -1, 'ub', 1);
assert(~isempty(s.terminalSet));

end