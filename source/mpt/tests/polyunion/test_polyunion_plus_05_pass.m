function test_polyunion_plus_05_pass
%
% unbounded,low-dim, full-dim,  non-overlapping union + full-dim polyhedron
%

P(1) = ExamplePoly.randHrep('d',2);
while P(1).isBounded
    P(1) = ExamplePoly.randHrep('d',2);
end

P(1).minHRep();
% take one face of P and revert it
H = [-P(1).H(1,:); [randn(5,2) ones(5,1)]];
P(2) = Polyhedron('H',H);

% take tha same second facet and bound it
P(3) = Polyhedron('He',-P(1).H(1,:),'lb',[-2;-2],'ub',[2;2]);

U = PolyUnion('Set',P,'Overlaps',false);

W = 0.1*Polyhedron('lb',[-1;-1],'ub',[1;1]);

Un = U+W;

H = Un.convexHull;

for i=1:3
    if ~H.contains(P(i)) && ~P(i).isEmptySet
        error('P1 must be be contained inside convex hull.');
    end
end

if Un.isOverlapping
    error('No overlaps here.');
end


end
