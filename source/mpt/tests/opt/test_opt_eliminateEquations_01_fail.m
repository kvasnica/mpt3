function test_opt_eliminateEquations_01_fail
%
% too many equalities, inconsistent
%

Ae = randn(6,12);
be = randn(6,1);

S.Ae = [Ae; 2*Ae-3];
S.be = [be; 0.4*be];

S.A = randn(2,12);
S.b = [4;5];
S.lb = zeros(12,1);
S.f = ones(12,1);

% true solution
res=mpt_solve(S);

% construct problem must fail due constraint validation
problem = Opt(S);

end
