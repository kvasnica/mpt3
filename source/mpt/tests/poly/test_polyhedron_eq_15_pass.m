function test_polyhedron_eq_15_pass
% comparison of half-spaces fails (related to issues #75 and #94)

% x>=y in both representations
P1=Polyhedron([-1 1], 0);
P2=Polyhedron('R', [1 1; -1 -1; 1 -1], 'V', [0 0]);
assert(P1==P2);
assert(P2==P1);

% x>=y+1 in both representations
P1=Polyhedron([-1 1], -1);
P2=Polyhedron('R', [1 1; -1 -1; 1 -1], 'V', [1 0]);
assert(P1==P2);

end
