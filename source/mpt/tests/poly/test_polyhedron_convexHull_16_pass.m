function test_polyhedron_convexHull_16_pass
%
% array of polyhedra
%

P = Polyhedron(randn(15,3));

for i=1:size(P.V,1)
    R(i)=Polyhedron('V',[P.V(i,:); zeros(1,P.Dim)]);
end

Hnew = PolyUnion(R).convexHull();

Pn = Polyhedron('H',Hnew.H,'He',Hnew.He);

if ~(Pn==P)
    error('Wrong computatation of convex hull for arrays.');
end

end
