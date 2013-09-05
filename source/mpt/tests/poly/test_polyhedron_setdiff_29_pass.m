function test_polyhedron_setdiff_29_pass
% set difference between R^n and a polyhedron

R = Polyhedron.fullSpace(2);
B = Polyhedron.unitBox(2);
P = Polyhedron([1 0], 1);

S = R\B;
assert(numel(S)==4);
assert(all(isFullDim(S)));
assert(all(~isBounded(S)));

S = R\P;
expected = Polyhedron([-1 0], -1);
assert(numel(S)==1);
assert(S==expected);

end
