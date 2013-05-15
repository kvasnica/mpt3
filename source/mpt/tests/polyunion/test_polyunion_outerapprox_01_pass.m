function test_polyunion_outerapprox_01_pass
%
% bounding boxes for unions of polyhedra
%
% H-V polyhedron

P(1) = ExamplePoly.randHrep;
while ~P(1).isBounded
    P(1) = ExamplePoly.randHrep;
end
P(2) = ExamplePoly.randVrep;

U = PolyUnion(P);

B = U.outerApprox;
H = U.convexHull;
Hb = H.outerApprox;

if norm(B.Internal.lb-Hb.Internal.lb,Inf)>1e-4
    error('LB do not match.');
end
if norm(B.Internal.ub-Hb.Internal.ub,Inf)>1e-4
    error('UB do not match.');
end

end


