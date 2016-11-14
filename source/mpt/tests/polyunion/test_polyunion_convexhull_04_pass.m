function test_polyunion_convexhull_04_pass
%
% low-dim polyhedron + unbounded 
%

P(1) = Polyhedron('lb',[-1;-1],'ub',[1;1]);
P(2) = Polyhedron('lb',[-1;-1],'ub',[1;1],'Ae',randn(1,2),'be',0);
P(3) = Polyhedron('V',[1 -1;1 1],'R',[1 0]);
P(4) = Polyhedron;
U = PolyUnion(P);

H = U.convexHull;

if numel(H)~=1
    error('One polyhedra must be here.');
end

for i=1:3
    if ~H.contains(U.Set(i))
        error('This set must be contained inside the convex hull.');
    end
end


end