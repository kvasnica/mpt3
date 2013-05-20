function test_polyhedron_extreme_06_pass
%
% intersection of two unbounded polyhedra
%


P = Polyhedron('R',[3 5 -9; 0 1 4.6],'lb',[-10;-10;-10]);
R = Polyhedron('He',[5 -9 0.1 9.3]);

S = P.intersect(R);

% all vertices must lie inside both sets (vertices should be automatically
% computed by lazy getters)
assert(~isempty(S.V));
if ~all(P.contains(S.V')) || ~all(R.contains(S.V'))
    error('All vertices must be contained inside P and R.');
end

end
