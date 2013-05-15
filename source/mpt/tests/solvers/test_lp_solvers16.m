function test_lp_solvers16(solver, tol)
% chebycenter problem
global MPTOPTIONS

load data_lp_solvers_16

S.A  = [P.A sqrt(sum(P.A.*P.A,2))];
S.b = P.b;
S.lb = [-Inf(P.Dim,1); 0];
% upper bounds
S.ub = [Inf(P.Dim,1); Inf];

% the last value is -1 because it is maximization
S.f = [zeros(P.Dim,1);-1];

% add solver
S.solver=solver;

% solve problem
ret = mpt_solve(S);

% compare results
if norm(ret.xopt(end)-1)>tol || ret.exitflag~=MPTOPTIONS.OK
    error('Solution does not match with given tolerance.');
end

end