function test_lp_cycling08(solver, tol)
% test on cycling in LP problems
% web.ist.utl.pt/ist11038/acad/or/LP/GassVinja.pdf

fname = mfilename;
check_LPsolvers;

% problem 4.8
S.f = [0, 0, -2, -2,  8, 2];

S.A = [];
S.b = [];
S.Ae = [1,  0, -7, -3,  7,  2;
        0,  1,  2,  1, -3, -1];    
S.be = [0; 0];
S.lb = zeros(6,1);

S.solver = solver;

% given solution
xd = zeros(6,1);
fvald = 0;

% call mpt_solve
R = mpt_solve(S);

% compare results
if norm(R.xopt-xd,Inf)>tol
    error('Results are not equal within a given tolerance.');
end
if norm(R.obj-fvald,Inf)>tol
    error('Results are not equal within a given tolerance.');
end

%mbg_asserttolequal(R.xopt,xd,tol);
%mbg_asserttolequal(R.obj,fvald,tol);

end
