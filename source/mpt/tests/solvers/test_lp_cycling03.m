function test_lp_cycling03(solver, tol)
% testing cycling in LP problems
% web.ist.utl.pt/ist11038/acad/or/LP/GassVinja.pdf

% problem 4.3
S.f = -[0, 0, 1, -1, 1, -1, 0];

S.A = [];
S.b = [];
S.Ae = [1,  0,  2,  -3, -5,  6, 0;
        0,  1,  6,  -5, -3,  2, 0;
        0,  0,  3,   1,  2,  4, 1];
    
S.be = [0; 0; 1];
S.lb = zeros(7,1);

S.solver = solver;

xd = zeros(7,1);
xd(1) = 2.5;
xd(2) = 1.5;
xd(5) = 0.5;
fvald = -0.5;

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
