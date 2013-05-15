function test_polyunion_plus_04_pass
%
% unbounded, non-overlapping union + full-dim polyhedron
%

P(1) = ExamplePoly.randHrep('d',2);
while P(1).isBounded
    P(1) = ExamplePoly.randHrep('d',2);
end

P(1).minHRep();

% take one face of P and revert it
H = [-P(1).H(1,:); [randn(5,2) ones(5,1)]];

P(2) = Polyhedron('H',H);

U = PolyUnion('Set',P,'Overlaps',false);

W = 0.1*Polyhedron('lb',[-1;-1],'ub',[1;1]);

Un = U+W;

H = U.convexHull;

if ~H.contains(P(1))
    error('P1 must be be contained inside convex hull.');
end
if ~H.contains(P(2))
    error('P2 must be be contained inside convex hull.');
end

if Un.isOverlapping
    error('No overlaps here.');
end


end
