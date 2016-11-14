function test_polyunion_merge_02_pass
%
% greedy merging- empty polyunion
%

P = ExamplePoly.randHrep;
U = PolyUnion(P);

U.merge;

if U.Num~=1
    error('Must be 1 region.')
end


end