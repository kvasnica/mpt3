function test_polyunion_outerapprox_03_pass
%
% bounding boxes for unions of polyhedra
%
% unbounded-bounded polyhedron

P(1) = ExamplePoly.randVrep('d',5,'nr',3);
P(2) = ExamplePoly.randHrep('d',5,'ne',2);

U = PolyUnion(P);

B = U.outerApprox;

if B.isBounded
    error('Bounding box should be unbounded for unbounded polyhedron.');
end

end


