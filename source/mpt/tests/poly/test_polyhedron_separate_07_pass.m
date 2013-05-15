function test_polyhedron_separate_07_pass
%
% two affine sets
%

P = Polyhedron('Ae',randn(2,3),'be',rand(2,1));

Q = P+[1;1;1];
h = P.separate(Q);

T = Polyhedron('He',h);
d1 = T.distance(P);
d2 = T.distance(Q);

if norm(d1.dist-d2.dist,Inf)>1e-3
    error('The distance does not match.');
end

end