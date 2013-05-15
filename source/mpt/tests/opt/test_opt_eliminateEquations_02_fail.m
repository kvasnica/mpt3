function test_opt_eliminateEquations_02_fail
%
% eliminate equations does not work for other than FEAS/LP/QP
%

Q = randn(4);
S.M = Q'*Q/sqrt(2);
S.q = randn(4,1);

problem = Opt(S);

problem.eliminateEquations

end
