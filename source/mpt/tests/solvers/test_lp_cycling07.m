function test_lp_cycling07(solver, tol)
% test on cycling in LP problems
% web.ist.utl.pt/ist11038/acad/or/LP/GassVinja.pdf

fname = mfilename;
check_LPsolvers;

% problem 4.7
S.f = [0, 0, 0, 0, -0.4, -0.4, 1.8];

S.A = [];
S.b = [];
S.Ae = [1,  0,  0,  0,  0.6, -6.4, 4.8;
        0,  1,  0,  0,  0.2, -1.8, 0.6;
        0,  0,  1,  0,  0.4, -1.6, 0.2;
        0,  0,  0,  1,    0,    1,    0];
    
S.be = [0; 0; 0; 1];
S.lb = zeros(7,1);

S.solver = solver;

% given solution
xd = zeros(7,1);
xd(1) = 4;
xd(2) = 1;
xd(5) = 4;
xd(6) = 1;
fvald = -2;

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
