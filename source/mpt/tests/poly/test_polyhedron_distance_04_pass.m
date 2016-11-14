function test_polyhedron_distance_04_pass
%
% low-dim, 3D, exact distance
%

P(1) = Polyhedron('He',[1 1 2 0;-2 0 1 0],'lb',[-5;-5;-5],'ub',[5;5;5]);


d=P.distance([1;-5;3]);


if norm(d.dist-1)>1e-4
    error('Wrong distance.');
end

end