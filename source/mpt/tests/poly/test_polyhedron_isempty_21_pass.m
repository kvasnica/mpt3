function test_polyhedron_isempty_21_pass
% wrong output in trivial 1D case

% all fine with V=1
V = 1;
Q = Polyhedron(V);
assert(~Q.isEmptySet);

% bug with V=0
V = 0;
Q = Polyhedron(V);
assert(~Q.isEmptySet);

end
