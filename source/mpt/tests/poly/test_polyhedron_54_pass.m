function test_polyhedron_54_pass
% only explicit equalities

He = [1 0 0; 2 0 0];
P = Polyhedron('He', He);
assert(isempty(P.H));
He_exp = [1 0 0];
assert(norm(P.He-He_exp)<1e-6);

end
