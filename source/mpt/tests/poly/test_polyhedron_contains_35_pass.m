function test_polyhedron_contains_35_pass
% unit box does not contain a positive orthant (issue #99)

%% unitbox does not contain the positive orthant
B = Polyhedron.unitBox(2);
% H-rep
P = Polyhedron(-eye(2), zeros(2, 1));
assert(~B.contains(P));

% V-rep (origin + rays)
P = Polyhedron('V', [0 0], 'R', 0.1*eye(2));
assert(~B.contains(P));

% V-rep (only rays)
P = Polyhedron('R', eye(2));
assert(~B.contains(P));

%% the orthant does not contain the box
B = Polyhedron.unitBox(2);

% H-rep
P = Polyhedron(-eye(2), zeros(2, 1));
assert(~P.contains(B));

% V-rep (origin + rays)
P = Polyhedron('V', [0 0], 'R', 0.1*eye(2));
assert(~P.contains(B));

% V-rep (only rays)
P = Polyhedron('R', eye(2));
assert(~P.contains(B));

%% but the orthant contains an another box
B = Polyhedron('lb', [1; 1], 'ub', [2; 2]);
% H-rep
P = Polyhedron(-eye(2), zeros(2, 1));
assert(P.contains(B));

% V-rep (origin + rays)
P = Polyhedron('V', [0 0], 'R', 0.1*eye(2));
assert(P.contains(B));

% V-rep (only rays)
P = Polyhedron('R', eye(2));
assert(P.contains(B));

%% half-space x(1)>=-1 contains the orthant
H = Polyhedron('H', [-1 0 1]);
% H-rep
P = Polyhedron(-eye(2), zeros(2, 1));
assert(H.contains(P));

% V-rep (origin + rays)
P = Polyhedron('V', [0 0], 'R', 0.1*eye(2));
assert(H.contains(P));

% V-rep (only rays)
P = Polyhedron('R', eye(2));
assert(H.contains(P));

%% half-space x(1)>=1 does not contain the orthant
H = Polyhedron('H', [-1 0 -1]);
% H-rep
P = Polyhedron(-eye(2), zeros(2, 1));
assert(~H.contains(P));

% V-rep (origin + rays)
P = Polyhedron('V', [0 0], 'R', 0.1*eye(2));
assert(~H.contains(P));

% V-rep (only rays)
P = Polyhedron('R', eye(2));
assert(~H.contains(P));

end
