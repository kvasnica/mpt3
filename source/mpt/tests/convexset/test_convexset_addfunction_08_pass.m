function test_convexset_addfunction_08_pass
%
% test removeFunction on single polyhedra
%

R = Polyhedron('lb', -1, 'ub', 1);
R.addFunction(AffFunction(1, 1), 'f');
R.removeFunction('f');
assert(isempty(R.listFunctions));

R.addFunction(AffFunction(1, 1), 'g');
R.addFunction(AffFunction(1, 1), 'f');
% containers.Map stores keys sorted
assert(isequal(R.listFunctions, {'f', 'g'}));

R.removeFunction('f');
assert(R.hasFunction('g'));
assert(~R.hasFunction('f'));

end
