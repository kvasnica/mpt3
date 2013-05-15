function test_polyunion_merge_08_pass
%
% greedy merging, partition from pwa_sincos example
%

load data_polyunion_merge_01
Q = [];
for i = 1:length(P)
	Q = [Q Polyhedron('H', P(i).H, 'He', P(i).He)];
end
U = PolyUnion('set',Q,'overlaps',true,'bounded',true,'fulldim',true);

U.merge;

% 34 regions should be from reducing the union
if U.Num>34
    error('Must be less than 34 regions.')
end


end
