function test_polyhedron_setdiff_21_pass
%
% set difference between two low-dim polytopes
%

V1 = [1 1; 3 1];
V2 = [1.5 1; 2.5 1];
P1 = Polyhedron(V1).minHRep();
P2 = Polyhedron(V2).minHRep();
R = P1\P2;

D1 = Polyhedron([1 1; 1.5 1]).minHRep();
D2 = Polyhedron([2.5 1; 3 1]).minHRep();
assert(numel(R)==2);
assert( (R(1)==D1 && R(2)==D2) || (R(1)==D2 && R(2)==D1) );

end
