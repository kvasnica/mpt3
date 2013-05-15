function test_polyunion_contains_06_pass
%
% 1D-polyhedron, two and three outputs
%

P = PolyUnion(Polyhedron('lb', -1, 'ub', 1));
Q = [P P];
[a1, b1, c1] = Q.contains(0);

if ~a1
    error('The point is inside.');
end

[a2, b2, c2] = Q.contains(2);

if a2
    error('The point is not inside.');
end

if ~iscell(c1) || ~iscell(c2) || ~iscell(b1) || ~iscell(b2)
    error('Here should be cell output.');
end



end
