function test_polyhedron_separate_10_pass
%
% vector vs 8D
%

P = 0.5*ExamplePoly.randVrep('d',8);

x = 10*rand(8,1);
h = P.separate(x);

T = Polyhedron('He',h);

d1 = P.distance(T);
d2 = T.distance(x);

if norm(d1.dist-d2.dist,Inf)>1e-4
    error('Distance must be the same.');
end

end