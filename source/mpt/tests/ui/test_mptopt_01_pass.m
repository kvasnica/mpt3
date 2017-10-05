function test_mptopt_01_pass
% mptopt('modules.module.submodule.property', value) must work

%% getter
m = mptopt;
p1 = 'modules.ui.invariantSet.maxIterations';
p2 = 'modules.geometry.sets.Polyhedron.projection';
e1 = m.modules.ui.invariantSet.maxIterations;
e2 = m.modules.geometry.sets.Polyhedron.projection;
v1 = get(mptopt, p1);
v2 = get(mptopt, p2);
assert(isequal(v1, e1));
assert(isequal(v2, e2));

%% setting non-existing property must fail
[~, msg] = run_in_caller('mptopt(''modules.ui.invariantSet2.maxIterations'', 2000)');
asserterrmsg(msg, 'No such property "modules.ui.invariantSet2".');

%% setter with insufficient number of inputs
[~, msg] = run_in_caller('mptopt(''lpsolver'')');
asserterrmsg(msg, 'mptopt: Input arguments following the object name must be pairs of the form PropertyName, PropertyValue');

%% setting anything but double/char must fail
[~, msg] = run_in_caller('mptopt(''lpsolver'', struct(''a'', 1))');
asserterrmsg(msg, 'The value must be a double or a string.');

%% single property
m = mptopt;
old = m.modules.ui.invariantSet.maxIterations;
new = old+1;
mptopt('modules.ui.invariantSet.maxIterations', new);
assert(m.modules.ui.invariantSet.maxIterations==new);
mptopt('modules.ui.invariantSet.maxIterations', old);
assert(m.modules.ui.invariantSet.maxIterations==old);
% setting basic properties
old = m.pqpsolver;
new = 'MPQP';
mptopt('pqpsolver', new);
assert(isequal(m.pqpsolver, new));
mptopt('pqpsolver', old);
assert(isequal(m.pqpsolver, old));

%% multiple property
m = mptopt;
p1 = 'modules.ui.invariantSet.maxIterations';
p2 = 'modules.geometry.sets.Polyhedron.projection.method';
v1 = m.modules.ui.invariantSet.maxIterations;
v2 = m.modules.geometry.sets.Polyhedron.projection.method;
v1n = v1+1;
v2n = 'new';
mptopt(p1, v1n, p2, v2n);
mptopt();
assert(isequal(m.modules.ui.invariantSet.maxIterations, v1n));
assert(isequal(m.modules.geometry.sets.Polyhedron.projection.method, v2n));
assert(isequal(get(m, p1), v1n));
assert(isequal(get(m, p2), v2n));
mptopt(p1, v1, p2, v2);
assert(isequal(m.modules.ui.invariantSet.maxIterations, v1));
assert(isequal(m.modules.geometry.sets.Polyhedron.projection.method, v2));
assert(isequal(get(m, p1), v1));
assert(isequal(get(m, p2), v2));

end
