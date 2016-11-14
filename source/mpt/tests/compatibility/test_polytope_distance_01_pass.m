function test_polytope_distance_01_pass

P = polytope([eye(2); -eye(2)], ones(4, 1));

% distance between a polytope and a point
x = [2;2];
d = distance(P, x);
d_expected = sqrt(2);
assert(abs(d-d_expected)<1e-8);

% distance between two polytopes
Q = P+[4;4];
d = distance(P, Q);
d_expected = 2*sqrt(2);
assert(abs(d-d_expected)<1e-8);

end
