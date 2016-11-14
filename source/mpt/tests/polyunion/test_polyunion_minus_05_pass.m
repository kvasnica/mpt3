function test_polyunion_minus_05_pass
%
% unbounded,low-dim, full-dim - full-dim polyhedron
%

P(1) = ExamplePoly.randHrep('d',2);
while P(1).isBounded
    P(1) = ExamplePoly.randHrep('d',2);
end

P(1).minHRep();
% take one face of P and revert it
H = [-P(1).H(1,:); [randn(5,2) ones(5,1)]];
P(2) = Polyhedron('H',H);

% take the same second facet and bound it
P(3) = Polyhedron('He',-P(1).H(1,:),'lb',[-2;-2],'ub',[2;2]);

U = PolyUnion('Set',P);

W = 0.1*Polyhedron('lb',[-1;-1],'ub',[1;1]);

Un = U-W;

H = Un.convexHull-W;

for i=1:Un.Num
    if ~H.contains(Un.Set(i))
        error('Each must be be contained inside convex hull.');
    end
end


end
