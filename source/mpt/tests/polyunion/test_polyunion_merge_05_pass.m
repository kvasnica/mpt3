function test_polyunion_merge_05_pass
%
% greedy merging- convex, non-overlapping union
%

P = ExamplePoly.randZono('d',2);
T = P.triangulate;
U = PolyUnion('Set',T,'convex',true,'overlaps',false);

U.merge;

if U.Num~=1
    error('Must be 1 region.')
end


end