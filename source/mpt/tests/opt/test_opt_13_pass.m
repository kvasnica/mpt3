function test_opt_13_pass
% problem contains double sided inequalities

global MPTOPTIONS


% simple lower and upper bounds
S.lb = -100*ones(3,1);
S.ub = 90*ones(3,1);

% inequality matrix
A = [1 2 3;
    0.4 -0.1 1.5;
    2 -0.0001 3.56];
S.A = [A; -A; 1 0 5.2];
S.b = [2; -19; 1; -2; 19; -1; 4];

% cost function
S.f = [0;0;-1];

% call mpt_solve
R = mpt_solve(S);

% call Opt
res = Opt(S).solve;

% solution as given by CPLEX
xd =[  40.598581284617623
  14.491038065034763
 -22.526885804895713];


% compare results
if norm(xd-R.xopt,Inf)>MPTOPTIONS.rel_tol
    error('Solution does not match with given tolerance.');
end

if norm(xd-res.xopt,Inf)>MPTOPTIONS.rel_tol
    error('Solution does not match with given tolerance.');
end

end