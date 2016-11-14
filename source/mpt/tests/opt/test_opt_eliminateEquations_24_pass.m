function test_opt_eliminateEquations_24_pass
%
% MILP with all binaries
% 

m = 131; n = 31; me=16;
S.A = randn(m,n);
S.b = 13*rand(m,1);
S.f = zeros(n,1);
S.Ae = 5*randn(me,n);
S.be = randn(me,1);

%% assume now that some variables are binary
S.vartype = repmat('B',1,n);

% formulate problem
problem = Opt(S);

% eliminate equations
[~,msg] = run_in_caller('problem.eliminateEquations');

asserterrmsg(msg,'Elimination cannot proceed because there are no continuous variables to eliminate.')

end