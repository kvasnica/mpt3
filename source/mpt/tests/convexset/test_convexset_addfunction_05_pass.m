function test_convexset_addfunction_05_pass
%
% test that the polyhedron copy constructor does deep copy on functions
%

P = Polyhedron();
f1 = @(x) x;
f2 = @(x) 2*x;
P.addFunction(f1, 'f');
Q = Polyhedron(P);
assert(isequal(P.listFunctions, {'f'}));
assert(isequal(Q.listFunctions, {'f'}));

Q.addFunction(f2, 'g');
assert(isequal(P.listFunctions, {'f'}));
assert(isequal(Q.listFunctions, {'f', 'g'}));

end
