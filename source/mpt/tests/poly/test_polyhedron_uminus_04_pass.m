function test_polyhedron_uminus_04_pass
%
% empty polyhedron
%

P = Polyhedron;

T = -P;

if ~isEmptySet(T)
    error('Polyhedra must be empty.');
end

end