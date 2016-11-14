function test_polyhedron_projection_01_pass
%
% empty polyhedron
%

Q = Polyhedron(randn(43,4),randn(43,1));

R=Q.projection([1:2]);

if ~R.isEmptySet
    error('R must be empty.');
end

end