function test_polyhedron_separate_09_pass
%
% vector
%

P = Polyhedron('lb',[2;3],'ub',[3;4]);

h = P.separate([5;5]);

T = Polyhedron('He',h);

d1 = P.distance(T);
d2 = T.distance([5;5]);

if norm(d1.dist-d2.dist,Inf)>1e-4
    error('Distance must be the same.');
end

end