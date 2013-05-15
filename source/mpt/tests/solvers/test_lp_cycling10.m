function test_lp_cycling10(solver, tol)
% test on cycling in LP problems
% web.ist.utl.pt/ist11038/acad/or/LP/GassVinja.pdf

% problem 4.11
S.f = -[0, -3, 1, -6,  0, -4, 0,  0];

S.A = [];
S.b = [];
S.Ae = [  1,  1,   0,   0,  1/3,  1/3, 0,  0;
          0,  9,   1,  -9,   -2, -1/3, 1,  0; 
          0,  1, 1/3,  -2, -1/3, -1/3, 0,  1];
S.be = [2; 0; 2];
S.lb = zeros(8,1);
% added upper bound because the solution appears to be unbounded
S.ub = 10*ones(8,1); 

S.solver = solver;

% call mpt_solve
R = mpt_solve(S);

% since multiple solutions exist we test constraint fulfillment
if norm(S.Ae*R.xopt-S.be,Inf)>tol
    error('Equality constraints are not satisfied.');
end

%mbg_asserttolequal(R.xopt,xd,tol);
%mbg_asserttolequal(R.obj,fvald,tol);

end
