function test_filter_setconstraint_02_pass
% copying before setting does not work (same as issue #105)

s = SystemSignal(1);
s.setKind('x');
s.with('setConstraint');
q = s.copy(); % must work
q.setConstraint = Polyhedron('lb', -1, 'ub', 1);
assert(isempty(s.setConstraint));
s.setConstraint = Polyhedron('lb', -1, 'ub', 1);
assert(~isempty(s.setConstraint));

end