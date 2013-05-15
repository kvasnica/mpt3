function test_polyhedron_distance_05_pass
%
% P-S polytopes, exact distance
%

P = Polyhedron('lb',[-3;-4;-5],'ub',[4;4;4]);
S = Polyhedron('lb',[-2;-5;5],'ub',[7;8;9]);

d=P.distance(S);


if norm(d.dist-1)>1e-4
    error('Wrong distance.');
end

end