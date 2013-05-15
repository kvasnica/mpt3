function test_qp_solvers06(solver, tol)

% test program for QP, taken from NAG documentation manual
% 
% original source:
% Bunch J R and Kaufman L C (1980): A Computational Method for the Indefinite
% Quadratic Programming Problem Linear Algebra and its Applications, 34, 341–37


% NOTE THAT H is not positive semi-definite (some solvers have troubles
% with that)
H = [1.69    1.00    2.00      3.00      4.00      5.00      6.00      7.00;
     1.00    1.69    1.00      2.00      3.00      4.00      5.00      6.00;
     2.00    1.00    1.69      1.00      2.00      3.00      4.00      5.00;
     3.00    2.00    1.00      1.69      1.00      2.00      3.00      4.00;
     4.00    3.00    2.00      1.00      1.69      1.00      2.00      3.00;
     5.00    4.00    3.00      2.00      1.00      1.69      1.00      2.00;
     6.00    5.00    4.00      3.00      2.00      1.00      1.69      1.00;
     7.00    6.00    5.00      4.00      3.00      2.00      1.00      1.69];


A = [-1 1 0 0 0 0 0 0;
     0 -1 1 0 0 0 0 0;
     0 0 -1 1 0 0 0 0;
     0 0 0 -1 1 0 0 0;
     0 0 0 0 -1 1 0 0;
     0 0 0 0 0 -1 1 0;
     0 0 0 0 0 0 -1 1];
l = [-1; -2.1; -3.2; -4.3; -5.4; -6.5; -7.6; -8.7];
la = [-1:-0.05:-1.3]';
u = [1:8]';
c = [7 6 5 4 3 2 1 0];
%xstart = -1*ones(8,1);

xd = [-1.0,-2.0,-3.05,-4.15,-5.3,6.0,7.0,8.0]';
fd = -6.214878249999999e+02;

% solve via old MPT interface
%[x1,~,~,~,f1] = mpt_solveQP(H,c,[eye(length(l));-eye(length(u));A;-A],...
%    [u;-l;1e12*ones(size(la));-la],[],[],xstart,solver);

% create structure S
S.H = H;
S.f = c;
S.A = -A;
S.b = -la;
S.ub = u;
S.lb = l;
S.solver = solver;

% call mpt_solve
R = mpt_solve(S);

% compare results
if norm(R.xopt-xd,Inf)>tol
    error('Results are not equal within a given tolerance.');
end
if norm(R.obj-fd,Inf)>tol
    error('Results are not equal within a given tolerance.');
end

%mbg_asserttolequal(R.obj,fd,tol);
%mbg_asserttolequal(R.xopt,xd,tol);

end
