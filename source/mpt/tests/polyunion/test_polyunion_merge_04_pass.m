function test_polyunion_merge_04_pass
%
% greedy merging- box,low-dim contained inside the box, unbounded
%

P(1) = Polyhedron('lb',[-1;-1],'ub',[1;1]);
P(2) = Polyhedron('lb',[-1;-1],'ub',[1;1],'Ae',randn(1,2),'be',0);
P(3) = Polyhedron('V',[1 -1;1 1],'R',[1 0]);
U = PolyUnion(P);

U.merge;

if U.Num~=1
    error('Must be 1 region.')
end


end