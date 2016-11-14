function test_polyhedron_projection_04_pass
%
% infeasible polyhedron
%

P = Polyhedron(10*randn(86,5),randn(86,1));

while ~P.isEmptySet
    P = Polyhedron(randn(86,5),randn(86,1));
end

R=P.projection([1,2]);

if ~isEmptySet(R)
    error('Must be the empty polyhedron.');
end

end