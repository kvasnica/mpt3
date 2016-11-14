function test_polyhedron_unitbox_01_pass
% tests Polyhedron.unitBox(dim)

B = Polyhedron.unitBox(2);
assert(isa(B, 'Polyhedron'));
assert(B.Dim==2);
assert(B.hasHRep);
assert(B.irredundantHRep);
assert(isequal(B.H, [[-eye(2); eye(2)], ones(4, 1)]));
assert(isempty(B.He));

end
