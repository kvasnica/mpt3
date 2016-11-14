function test_lp_solvers01(solver, tol)
% load example file (taken from
% http://www.mathworks.com/access/helpdesk/help/toolbox/optim/ug/brn4nj4.html)

fname = mfilename;
check_LPsolvers;

load sc50b
%solution 

xd = [30.0000
   28.0000
   42.0000
   70.0000
   70.0000
   30.0000
   28.0000
   42.0000
   30.0000
   28.0000
   42.0000
   33.0000
   30.8000
   46.2000
   77.0000
  147.0000
   63.0000
   58.8000
   88.2000
   63.0000
   58.8000
   88.2000
   36.3000
   33.8800
   50.8200
   84.7000
  231.7000
   99.3000
   92.6800
  139.0200
   99.3000
   92.6800
  139.0200
   39.9300
   37.2680
   55.9020
   93.1700
  324.8700
  139.2300
  129.9480
  194.9220
  139.2300
  129.9480
  194.9220
   43.9230
   40.9948
   61.4922
  102.4870];

fvald = -70;

% use old MPT interface to solve it
%[x1,fval1]=mpt_solveLP(f,full(A),b,full(Aeq),beq,x0,solver,lb,1e4*ones(size(lb)));

% create structure S
S.f = f;
S.A = A;
S.b = b;
S.Ae = Aeq;
S.be = beq;
S.lb = lb;
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
