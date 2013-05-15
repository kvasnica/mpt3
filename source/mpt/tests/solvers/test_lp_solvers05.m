function test_lp_solvers05(solver, tol)
% test program
% no equality constraints

% initial data
load data_test_lp05

% solution
xd = [    2.135337743233658
   5.000000000000000
  -6.087871265132302
   5.000000000000000
  -1.269930862821592
   5.000000000000002
   4.999999999999997
   2.813759826397443
  -9.999999999999998
  -8.368169913552288
  -9.982311046865421
  -8.090360343234286
  -7.190798616280120
  -4.723384025434595
 -10.000000000000002
   0.935636511992259
   4.999999999999997
  -6.609130979813744
 -10.000000000000005
 -10.000000000000000
  -0.631474131284360
   5.000000000000000
 -10.000000000000000
  -2.844833086750089
   5.000000000000000];

fvald = -48.736412377489316;


% use MPT interface to solve it
%[x1,fval1] = mpt_solveLP(p.c,p.A,p.B,[],[],p.x0,solver,p.l,p.u);

% create structure S
S.f = p.c;
S.A = p.A;
S.b = p.B;
S.lb = p.l;
S.ub = p.u;
S.solver = solver;

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