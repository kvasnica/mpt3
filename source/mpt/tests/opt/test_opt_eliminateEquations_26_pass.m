function test_opt_eliminateEquations_26_pass
%
% MILP with more constraints than continuous variables to remove
% 

m = 131; n = 32; me=3;
S.A = randn(m,n);
S.b = 13*rand(m,1);
S.f = randn(n,1);
S.Ae = 5*randn(me,n);
S.be = randn(me,1);

% assume one continous variable
S.vartype = [repmat('B',1,15),'CC',repmat('B',1,15)];

% formulate problem and solve with equality constraints
problem = Opt(S);
r1 = problem.solve;

% eliminate equations and solve reduced problem
problem.eliminateEquations;

r2 = problem.solve;

if r1.exitflag ~= r2.exitflag
    error('The reduced problem must return the same flag as the original problem.')
end

end