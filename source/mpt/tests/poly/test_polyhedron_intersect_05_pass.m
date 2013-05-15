function test_polyhedron_intersect_05_pass
%
% empty-empty polyhedra
%

P = Polyhedron(randn(15,2),randn(15,1));
S = Polyhedron(randn(15,2),randn(15,1));

R = P.intersect(S);

if ~isEmptySet(R)
    error('Must be empty because S is empty.');
end


Pn = Polyhedron;
Sn = Polyhedron;

Rn = Pn.intersect(Sn);

if ~isEmptySet(Rn)
    error('Must be empty because Sn is empty.');
end


end