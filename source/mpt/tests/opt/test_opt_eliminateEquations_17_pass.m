function test_opt_eliminateEquations_17_pass
%
% eliminate equations does not work for other than FEAS/LP/QP
%

Q = randn(4);
S.M = Q'*Q/sqrt(2);
S.q = randn(4,1);

problem = Opt(S);

[worked, msg] = run_in_caller('problem.eliminateEquations ');
assert(~worked);
asserterrmsg(msg,'No equality removal for LCP type of problems.');

end
