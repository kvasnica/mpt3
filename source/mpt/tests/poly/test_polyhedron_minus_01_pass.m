function test_polyhedron_minus_01_pass
%
% empty polyhedra
%


P = Polyhedron;
S = Polyhedron;


R = P-S;

if ~R.isEmptySet
    error('R must be empty.');e
end

end