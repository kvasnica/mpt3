function test_lp_cycling01(solver, tol)
% testing cycling in LP problems
% web.ist.utl.pt/ist11038/acad/or/LP/GassVinja.pdf

fname = mfilename;
check_LPsolvers;

% problem 4.1
S.f = zeros(1,11);
S.f(4) = -2.2361;
S.f(5) = 5;
S.f(7) = 4;
S.f(8) = 3.6180;
S.f(9) = 3.236;
S.f(10) = 3.618;
S.f(11) = 0.764;

S.A = [];
S.b = [];
S.Ae = zeros(3,11);
S.Ae(1,1) = 1;
S.Ae(2,2) = 1;
S.Ae(2,4:11) = [0.309, -0.618, -0.809, -0.382, 0.809, 0.382, 0.309, 0.618];
S.Ae(3,3:11) = [1, 1.4635, 0.309, 1.4635, -0.8090, -0.9045, -0.8090, 0.4635, 0.309];
S.be = [1; 0; 0];
S.lb = zeros(11,1);

S.solver = solver;

xd = zeros(11,1);
xd(1) = 1;
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
