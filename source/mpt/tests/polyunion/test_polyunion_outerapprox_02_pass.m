function test_polyunion_outerapprox_02_pass
%
% bounding boxes for unions of polyhedra
%
% H-he-V polyhedron

P(1) = ExamplePoly.randHrep;
P(2) = ExamplePoly.randHrep('ne',1);
P(3) = ExamplePoly.randVrep;

while any(~P.isBounded)
    P(1) = ExamplePoly.randHrep;
    P(2) = ExamplePoly.randHrep('ne',1);
    P(3) = ExamplePoly.randVrep;
end    

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


