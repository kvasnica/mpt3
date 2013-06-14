function test_lp_solvers15(solver, tol)
% problem contains double sided inequalities

fname = mfilename;
check_LPsolvers;

% simple lower and upper bounds
S.lb = -100*ones(4,1);
S.ub = 90*ones(4,1);

% inequality matrix
A = [0.4 0.6 0.8 0; 1 -9 100 2256];
S.A = [A; -A; 1 0 -1 5.2];
S.b = [2; -19;-2; 19; 3];

% cost function
S.f = [0;0;0;-1];

% assign solver
S.solver = solver;

% call mpt_solve
R = mpt_solve(S);

% solution as given by CPLEX
xd =[ -48.858195009343731;
  90.000000000000000;
 -40.570902495328134;
   2.170633175772233];


% compare results
if norm(xd-R.xopt,Inf)>tol
    error('Solution does not match with given tolerance.');
end

%mbg_asserttolequal(R.xopt,p.xopt,tol);
%mbg_asserttolequal(R.obj,p.fopt,tol);

end