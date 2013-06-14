function test_qp_solvers03(solver, tol)
% load examples from qpOASES

fname = mfilename;
check_QPsolvers;

load example1   % Get matrices
%xstart = zeros(size(lb));

xd = [0.5; -1.5];
fd = -0.0625;

% solving via MPT interface
%[x,~,~,~,fval] = mpt_solveQP(H,g,[A;-A;eye(length(ub));-eye(length(lb))],...
%    [ubA;-lbA;ub;-lb],[],[],xstart,solver);

% create structure S
S.H = H;
S.f = g;
S.A = [A;-A];
S.b = [ubA; -lbA];
S.lb = lb;
S.ub = ub;
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
