function test_polyhedron_42_pass
% infeasible zero rows in equalities must be preserved (issue #80)

H = [1 1; -1 1];
He = [0 1];
P = Polyhedron('H', H, 'He', He);

% the equality is infeasible and hence must be preserved
assert(isequal(P.He, He));

end
