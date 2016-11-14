function test_polyhedron_distance_01_pass
%
% S is a real vector
%

P = Polyhedron('lb',-1,'ub',2);
S = 3;

s = P.distance(S);

if norm(s.dist-1)>1e-4
    error('Wrong distance.');
end

end