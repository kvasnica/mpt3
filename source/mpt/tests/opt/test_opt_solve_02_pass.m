function test_opt_solve_02_pass
% must allow changing the solver by the user

P = Opt('A', eye(2), 'b', [1;1]);

% existing solvers
P.solver = 'cdd';
P.solve();
P.solver = 'lcp';
P.solve();

% non-existing solver
P.solver = 'bogus';
[~, msg] = run_in_caller('P.solve()');
asserterrmsg(msg, 'mpt_solve: Yalmip error when calling BOGUS solver!');

% solver must be a string
[~, msg] = run_in_caller('P.solver=1');
asserterrmsg(msg, 'The solver must be a string.');

% solver must support problem class
P = Opt('A', eye(2), 'b', [1;1], 'H', eye(2));
P.solver = 'cdd';
[~, msg] = run_in_caller('P.solve()');
asserterrmsg(msg, 'mpt_call_cdd: CDD solver does not solve QP problems!');

% switching to a proper solver must work
P.solver = 'lcp';
P.solve();

% Opt/copy should leave the solver unchanged
Q = P.copy();
assert(isequal(Q.solver, 'LCP'));
Q.solver = 'quadprog';
assert(isequal(P.solver, 'LCP'));
assert(isequal(Q.solver, 'QUADPROG'));
P.solver = 'gurobi';
assert(isequal(Q.solver, 'QUADPROG'));

end
