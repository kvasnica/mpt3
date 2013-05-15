function test_polyhedron_interiorPoint_05_pass
%
% random He, one facet
%

P = Polyhedron('A',randn(25,8),'b',5*rand(25,1),'Ae',randn(3,8),'be',[1 2 0]);

while P.isEmptySet
    P = Polyhedron('A',randn(25,8),'b',5*rand(25,1),'Ae',randn(3,8),'be',[1 2 0]);
end

P.minHRep();
res = P.interiorPoint(2);

% create new polyhedra out of facet 2
H = P.H;
f = setdiff(1:size(H,1),2);
R = Polyhedron('H',H(f,:),'He',[H(2,:);P.He]);
if ~R.contains(res.x)
    error('The point must lie inside the set.');
end

end
