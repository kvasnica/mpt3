function test_polyunion_merge_03_pass
%
% greedy merging- bounded,bounded, unbunded
%

P(1) = Polyhedron('lb',-1,'ub',0);
P(2) = Polyhedron('lb',0,'ub',1);
P(3) = Polyhedron('lb',1);
U = PolyUnion(P);

U.merge;

if U.Num~=1
    error('Must be 1 region.')
end


end