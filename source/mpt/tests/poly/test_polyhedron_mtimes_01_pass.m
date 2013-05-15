function test_polyhedron_mtimes_01_pass
%
% empty -empty polyhedra
%

P = Polyhedron;
Q = Polyhedron(randn(80,2),randn(80,1));

R = P*Q;

if ~R.isEmptySet
    error('R must be empty.');
end

end
