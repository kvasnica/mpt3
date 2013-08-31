function test_polyhedron_project_12_pass
% wrong dimensions must be rejected

P = Polyhedron('lb', -1, 'ub', 1);
x = [1; 2]; % wrong dimension
[~, msg] = run_in_caller('P.project(x)');
asserterrmsg(msg, 'Input argument must have 1 rows.');

% these are two points in 1D, hence correct:
x = [1, 2];
sol = P.project(x);
assert(numel(sol)==2);

end
