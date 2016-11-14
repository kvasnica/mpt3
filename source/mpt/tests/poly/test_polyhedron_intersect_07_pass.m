function test_polyhedron_intersect_07_pass
%
% affine sets
%

P = Polyhedron('Ae',randn(2,3),'be',zeros(2,1));
S = Polyhedron('Ae',randn(1,3),'be',randn(1));

R = P.intersect(S);

if isEmptySet(R)
    error('The set is just a point.');
end


end