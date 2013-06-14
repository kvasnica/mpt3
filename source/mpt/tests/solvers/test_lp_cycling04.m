function test_lp_cycling04(solver, tol)
% test on cycling in LP problems
% web.ist.utl.pt/ist11038/acad/or/LP/GassVinja.pdf

fname = mfilename;
check_LPsolvers;

% problem 4.4
S.f = -[0, 0, 1, -1, 1, -1, 0];

S.A = [];
S.b = [];
S.Ae = [1,  0,  1,  -2, -3,  4, 0;
        0,  1,  4,  -3, -2,  1, 0;
        0,  0,  1,   1,  1,  1, 1];
    
S.be = [0; 0; 1];
S.lb = zeros(7,1);

S.solver = solver;

% given solution
xd = zeros(7,1);
xd(1) = 3;
xd(2) = 2;
xd(5) = 1;
fvald = -1;

% call mpt_solve
R = mpt_solve(S);

% since multiple solutions exist we test constraint fulfillment
% compare results
if norm(S.Ae*R.xopt-S.be,Inf)>tol
    error('Equality constraints are not satisfied.');
end
if norm(R.obj-fvald,Inf)>tol
    error('Results are not equal within a given tolerance.');
end

%mbg_asserttolequal(R.xopt,xd,tol);
%mbg_asserttolequal(R.obj,fvald,tol);

end
