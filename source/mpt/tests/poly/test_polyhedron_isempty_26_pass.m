function test_polyhedron_isempty_26_pass
% infeasible zero rows in equalities must be preserved (issue #80)

% this set is empty due to infeasibility of the equality constraints
H = [1 1; -1 1];
He = [0 1];
P = Polyhedron('H', H, 'He', He);

assert(P.isEmptySet);

end
