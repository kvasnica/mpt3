function test_polyunion_plus_03_pass
%
% overlapping union + full-dim polyhedron
%

P(1) = ExamplePoly.randHrep('d',2,'ne',1);
P(3) = ExamplePoly.randHrep('d',2);

U = PolyUnion(P);

% must be overlapping
while ~U.isOverlapping   
    P(1) = ExamplePoly.randHrep('d',2,'ne',1);
    P(3) = ExamplePoly.randHrep('d',2);
    
    U = PolyUnion(P);   
end

W = 0.1*ExamplePoly.randVrep('d',2);

Un = U+W;

H = U.convexHull();

if ~H.contains(P(1))
    error('P1 must be be contained inside convex hull.');
end
if ~H.contains(P(3))
    error('P3 must be be contained inside convex hull.');
end

if Un.isOverlapping
    error('No overlaps here.');
end


end
