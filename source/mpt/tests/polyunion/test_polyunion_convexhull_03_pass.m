function test_polyunion_convexhull_03_pass
%
% array of polyhedra
%

U(1) = PolyUnion(ExamplePoly.randHrep);

for i=1:10
    P(i) = ExamplePoly.randHrep;
end
for i=11:15
    P(i) = ExamplePoly.randVrep;
end

U(2) = PolyUnion(P);
H = U.convexHull;

if numel(H)~=2
    error('Two polyhedra must be here.');
end

if ~H(1).contains(U(1).Set)
    error('This set must be contained inside the convex hull.');
end

for i=1:15
    if ~H(2).contains(U(2).Set(i))
        error('This set must be contained inside the convex hull.');
    end
end


end