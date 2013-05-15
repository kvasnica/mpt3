function test_polyunion_plus_02_pass
%
% convex + full-dim polyhedron
%

P = ExamplePoly.randHrep;
T = P.triangulate;

U = PolyUnion('Set',T,'Convex',true);

W = 0.1*ExamplePoly.randVrep;

Un = U+W;

if ~Un.Set.contains(P)
    error('The object must be contained inside Un.');
end

if ~Un.isConvex
    error('Convexity remains unchanged.');
end
if Un.isOverlapping
    error('No overlaps here.');
end


end