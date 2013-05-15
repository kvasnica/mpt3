function test_polyunion_minus_02_pass
%
% convex + full-dim polyhedron
%

P = ExamplePoly.randHrep;

while ~P.isBounded
    P = ExamplePoly.randHrep;
end
T = P.triangulate;

U = PolyUnion('Set',T,'Convex',true);

W = 0.1*ExamplePoly.randVrep;

Un = U-W;

if ~P.contains(Un.Set)
    error('The object be contained inside P.');
end

if ~Un.isConvex
    error('Convexity remains unchanged.');
end

end