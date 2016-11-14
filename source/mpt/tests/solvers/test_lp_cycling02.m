function test_lp_cycling02(solver, tol)
% testing cycling in LP problems
% web.ist.utl.pt/ist11038/acad/or/LP/GassVinja.pdf

fname = mfilename;
check_LPsolvers;

% problem 4.2
S.f = [-3/4, 150, -1/50, 6, 0, 0, 0];

S.A = [];
S.b = [];
S.Ae = [1/4, -60, -1/25, 9, 1, 0, 0;
        1/2, -90, -1/50, 3, 0, 1, 0;
        0,     0,     1, 0, 0, 0, 1];
S.be = [0; 0; 1];
S.lb = zeros(7,1);

S.solver = solver;

xd = zeros(7,1);
xd(1) = 1/25;
xd(3) = 1;
xd(5) = 3/100;
fvald = -1/20;

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
