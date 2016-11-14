function test_lp_cycling06(solver, tol)
% test on cycling in LP problems
% web.ist.utl.pt/ist11038/acad/or/LP/GassVinja.pdf

fname = mfilename;
check_LPsolvers;

% problem 4.6
S.f = [2, 0, 0, 4, 0, 4];

S.A = [];
S.b = [];
S.Ae = [1, -3, -1, -1, -1,  1;
        0,  2,  1, -3, -1,  2];
    
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
