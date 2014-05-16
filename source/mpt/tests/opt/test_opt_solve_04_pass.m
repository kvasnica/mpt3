function test_opt_solve_04_pass

global MPTOPTIONS

prob = Opt('H', 1, 'f', 0, 'A', 0, 'b', 1, 'pB', 1, 'Ath', [1; -1], 'bth', [2; 1]);

% parameter in bounds => feasible
x0 = 2;
sol = prob.solve(x0);
assert(sol.exitflag==MPTOPTIONS.OK);
x0 = -1;
sol = prob.solve(x0);
assert(sol.exitflag==MPTOPTIONS.OK);
x0 = 0.2;
sol = prob.solve(x0);
assert(sol.exitflag==MPTOPTIONS.OK);

% parameter out of bounds => infeasible
x0 = 2+1e-5;
sol = prob.solve(x0);
assert(sol.exitflag==MPTOPTIONS.INFEASIBLE);
x0 = -1-1e-5;
sol = prob.solve(x0);
assert(sol.exitflag==MPTOPTIONS.INFEASIBLE);

end
