function test_milp_solvers05(solver, tol)
% test program
% no equality constraints

% initial data
load data_test_lp05

% add some binaries + integers
vartype = 'C'*ones(size(p.c))';
vartype(1) = 'B';
vartype(3:9) = 'I';
vartype(12:13) = 'B';
vartype = char(vartype);
% solution via CPLEX
xd = [                        0
     5.000000000000000e+00
     5.000000000000000e+00
    -1.000000000000000e+00
     2.000000000000000e+00
     5.000000000000000e+00
     5.000000000000000e+00
     5.000000000000000e+00
    -1.000000000000000e+01
    -6.289716311724313e+00
    -3.520362299010713e+00
                         0
                         0
    -4.366898588275972e+00
    -1.000000000000000e+01
    -5.478446743790825e+00
     5.000000000000000e+00
     7.479933133815551e-01
    -5.206450180924499e+00
    -3.536484116695930e+00
    -4.248275371432984e-01
     3.781801246391129e+00
    -8.600365309961262e+00
    -1.000000000000000e+01
     5.000000000000000e+00];

fvald = [-4.056293778738360e+01];


% use MPT interface to solve it
%[x1,fval1,h] = mpt_solveMILP(p.c,p.A,p.B,[],[],p.l,p.u,vartype,[],[],solver);

% create structure
S.f = p.c;
S.A = p.A;
S.b = p.B;
S.lb = p.l;
S.ub = p.u;
S.vartype = char(vartype);
S.solver = solver;

% solve
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