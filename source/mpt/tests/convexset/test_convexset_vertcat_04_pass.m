function test_convexset_vertcat_04_pass
%
% same objects, weird matrix concatenation
%

P1 = Polyhedron(randn(5));
P2 = Polyhedron(randn(3));
P3 = Polyhedron(randn(4,5));
P4 = Polyhedron('A', randn(16,8), 'b', randn(16,1), 'lb', -1*ones(8,1));

Set = [P1;[P2,[]];[[P3;P2];P1,P4]];


if size(Set,1)~=6
    error('Must be concatentenated into a column.');
end

end