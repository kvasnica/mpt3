function test_polyhedron_projection_07_pass
%
% polyhedron array in various dimensions
%

P(1) = Polyhedron('lb',-1,'ub',1);
P(2) = Polyhedron(randn(5,3),5*rand(5,1));
P(3) = ExamplePoly.randVrep('d',7,'nr',1);

R = P.projection(1);
T = R.outerApprox;
Tn = T.projection(1);

if R(1)~=P(1)
    error('Must be the same because it is in the same dimension.');
end

for i=2:3
    if T(i)~=Tn(i)
        error('Polyhedra are expected to be the same.');
    end
end


end