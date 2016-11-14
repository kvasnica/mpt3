function test_polyunion_merge_01_pass
%
% greedy merging- empty polyunion
%

U = PolyUnion;

U.merge;

if U.Num~=0
    error('Must be empty.')
end


end