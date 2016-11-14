function test_convexset_addfunction_09_pass
%
% test removeFunction on arrays of polyhedra
%

R(1) = Polyhedron('lb', -1, 'ub', 1);
R(2) = Polyhedron('lb', -1, 'ub', 1);
R.addFunction(AffFunction(1, 1), 'f');
R.removeFunction('f');
assert(isempty(R(1).listFunctions));
assert(isempty(R(2).listFunctions));

R.addFunction(AffFunction(1, 1), 'g');
R.addFunction(AffFunction(1, 1), 'f');
% containers.Map stores keys sorted
assert(isequal(R(1).listFunctions, {'f', 'g'}));
assert(isequal(R(2).listFunctions, {'f', 'g'}));

R.removeFunction('f');
assert(R(1).hasFunction('g'));
assert(R(2).hasFunction('g'));
assert(~R(1).hasFunction('f'));
assert(~R(2).hasFunction('f'));


end
