function test_convexset_addfunction_01_pass
%
% empty polyhedron, simple function
%

P = Polyhedron;
P.addFunction(Function(@(x)x), 'f');
