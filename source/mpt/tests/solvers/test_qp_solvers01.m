function test_qp_solvers01(solver, tol)
% load example file (taken from
% http://www.mathworks.com/access/helpdesk/help/toolbox/optim/ug/brn4nlc.html

load qpbox1   % Get H
%H = full(H);
lb = zeros(400,1); lb(400) = -1e6;
ub = 0.9*ones(400,1); ub(400) = 1e6;
f = zeros(400,1); f([1 400]) = -2;
%xstart = 0.1*ones(400,1);
xd = [0.9*ones(399,1); 0.95];
fd = -1.9850;

% solving QP by providing constraints in the form A*x<=B only
%--------------------------------------------------------------------------
%[xopt,lambda,how,exitflag,objqp]=mpt_solveQP(H,f,A,B,Aeq,Beq,x0,solver,options);
%[x1,~,~,~,fval1] = mpt_solveQP(H,f,[eye(400);-eye(400)],...
%    [ub; -lb],[],[],xstart,solver);

% create structure S
S.H = H;
S.f = f;
S.lb = lb;
S.ub = ub;
S.A = [];
S.b = [];
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
