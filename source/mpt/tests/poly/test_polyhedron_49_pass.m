function test_polyhedron_49_pass
% tests addining of a small eps to lower bound

eps = 1e-15;
UB = 1;
LB = UB+eps;

% we used to give an error here since the LB is not strictly smaller than
% the upper bound
P = Polyhedron('lb', LB, 'ub', UB);

end