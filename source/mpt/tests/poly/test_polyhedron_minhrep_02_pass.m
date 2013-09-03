function test_polyhedron_minhrep_02_pass
% polyhedron reducing to R^n

P = Polyhedron([0 0], 1);
P.minHRep();
assert(~isempty(P.H)); % must contain H-rep of R^n

P = Polyhedron([0 0; 0 0], [1; 2]);
[~, info] = P.minHRep();
assert(~isempty(P.H)); % must contain H-rep of R^n
assert(isequal(info.I, [false; true])); % the second inequality is redundant

end
