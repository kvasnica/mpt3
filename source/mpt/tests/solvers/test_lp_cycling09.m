function test_lp_cycling09(solver, tol)
% test on cycling in LP problems
% web.ist.utl.pt/ist11038/acad/or/LP/GassVinja.pdf

fname = mfilename;
check_LPsolvers;

% problem 4.10
S.f = [10, -57, -9, -24,  0, 0, 0];

S.A = [];
S.b = [];
S.Ae = [0.5, -5.5, -2.5,  9,  1,  0, 0;
        0.5, -1.5, -0.5,  1,  0,  1, 0; 
          1,    0,    0,  0,  0,  0, 1];
S.be = [0; 0; 1];
S.lb = zeros(7,1);
% added upper bound because the solution appears to be unbounded
S.ub = 10*ones(7,1); 

S.solver = solver;

% solution
xd = zeros(7,1);
xd(1) = 1;
xd(3) = 1;
xd(5) = 2;
fvald = 1;

% call mpt_solve
R = mpt_solve(S);

% since multiple solutions exist we test constraint fulfillment
if norm(S.Ae*R.xopt-S.be,Inf)>tol
    error('Equality constraints are not satisfied.');
end

%mbg_asserttolequal(R.xopt,xd,tol);
%mbg_asserttolequal(R.obj,fvald,tol);

end
