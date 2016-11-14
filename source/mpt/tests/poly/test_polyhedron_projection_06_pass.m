function test_polyhedron_projection_06_pass
%
% box in 8D
%

lb = -5*rand(8,1);
ub = 5*rand(8,1);
P = Polyhedron('lb',lb,'ub',ub);

R=P.projection([2,3]);

T = R.outerApprox;
if norm(T.Internal.lb-lb([2,3]),Inf)>1e-4
    error('Wrong lb.');
end
if norm(T.Internal.ub-ub([2,3]),Inf)>1e-4
    error('Wrong ub.');
end


end