function test_polyhedron_minvrep_01_pass
% minimal representation of rays must be computed as well

P = Polyhedron('V', [0 0; 0 0], 'R', [-1 0; 0 -1; 0 -2]);
assert(size(P.V, 1)==2);
assert(size(P.R, 1)==3);
P.minVRep();
Vexp = [0 0];
Rexp = [-1 0; 0 -1];
assert(isequal(P.V, Vexp));
assert(isequal(sortrows(P.R), Rexp));

end
