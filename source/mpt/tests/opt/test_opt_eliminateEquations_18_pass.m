function test_opt_eliminateEquations_18_pass
%
% equalities on the parameter
%

S.A = randn(10,14);
S.b = ones(10,1);
S.pB = randn(10,6);
S.Ae = [randn(1,14); zeros(5,14)];
S.be = rand(6,1);
S.pE = randn(6,6);
S.f = ones(14,1);
S.lb = -10*ones(14,1);

% construct problem
problem = Opt(S);

% solve problem must throw an error because the parameter space is not
% full-dimensional
[worked, msg] = run_in_caller('problem.solve; ');
assert(~worked);
asserterrmsg(msg,'PLCP solver does not solve problems with equality constraints. Try a different solver.');

end
