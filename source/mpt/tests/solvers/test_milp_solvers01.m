function test_milp_solvers01(solver, tol)
% load example file and change it slightly (taken from
% http://www.mathworks.com/access/helpdesk/help/toolbox/optim/ug/brn4nj4.html)

load sc50b
x0 = zeros(1,size(A,2));

% set some variables as binaries
vartype = 'C'*ones(size(x0));
vartype([10 15 16 26 29]) = 'B';

% change the cost slightly
 f(2) = -1;
 f(5) = 10;
 f(12) = -1.5;
 f(13) = 0.5;

% use old MPT interface to solve it
%[x1,fval1,how,exfl]=mpt_solveMILP(f,A,b,Aeq,beq,-1e9*ones(size(f)),1e9*ones(size(f)),char(vartype),[],[],solver);

% create structure
S.f = f;
S.A = A;
S.b = b;
S.Ae = Aeq;
S.be = beq;
S.vartype = char(vartype);
S.solver = solver;


% solution via CPLEX
xd = [ -1.500000000000000e+03
     1.600000000000000e+03
                         0
                         0
    -2.220446049250313e-16
    -1.500000000000000e+03
     1.600000000000000e+03
                         0
    -1.500000000000000e+03
                         0
    -1.332267629550188e-16
     1.200000000000000e+03
    -1.600000000000000e+03
                         0
                         0
                         0
    -3.000000000000000e+02
                         0
                         0
    -3.000000000000000e+02
                         0
                         0
                         0
                         0
                         0
                         0
    -4.440892098500626e-16
    -3.000000000000000e+02
                         0
                         0
    -3.000000000000000e+02
                         0
    -2.664535259100376e-16
                         0
                         0
                         0
                         0
    -6.661338147750939e-16
    -3.000000000000000e+02
                         0
                         0
    -3.000000000000000e+02
    -2.664535259100376e-16
    -3.996802888650563e-16
                         0
                         0
                         0
                         0];
                     
fvald = -4200;

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
