function test_polyhedron_projection_05_fail
%
% empty polyhedron
%

P = Polyhedron;

R=P.projection([1:2]);

if ~R.isEmptySet
    error('R must be empty.');
end

end