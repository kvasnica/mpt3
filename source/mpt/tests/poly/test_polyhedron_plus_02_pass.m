function test_polyhedron_plus_02_pass
%
% empty polyhedra
%


P = Polyhedron(randn(18,2),randn(18,1));
S = Polyhedron;


R = P+S;

if ~R.isEmptySet
    error('R must be empty.');
end

end