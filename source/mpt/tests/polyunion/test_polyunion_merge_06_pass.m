function test_polyunion_merge_06_pass
%
% greedy merging, overlapping regions, all regions are inside P(1)
%

P(1) = Polyhedron('lb',[-10;-10;-10],'ub',[10;10;10]);
P(2) = ExamplePoly.randVrep('d',3);
P(3) = ExamplePoly.randHrep('d',3,'ne',1);
P(4) = ExamplePoly.randVrep('d',3);

while ~P(1).contains(P(2))
    P(2) = ExamplePoly.randVrep;
end
while ~P(1).contains(P(3))
    P(3) = ExamplePoly.randVrep;
end
while ~P(1).contains(P(4))
    P(4) = ExamplePoly.randVrep;
end

U = PolyUnion(P);

U.merge;

if U.Num~=1
    error('Must be 1 region.')
end


end