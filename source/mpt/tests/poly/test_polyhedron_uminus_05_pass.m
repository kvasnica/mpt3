function test_polyhedron_uminus_05_pass
%
% infeasible polyhedron
%

P = Polyhedron('H',randn(64,5));

while ~P.isEmptySet
    P = Polyhedron(randn(64,5));
end

T = -P;

if ~isEmptySet(T)
    error('Polyhedra must be empty.');
end

end