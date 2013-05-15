function test_opt_qp2lcp_16_pass
%
% must fail because A,b are row-dependent and pB is not 
%

global MPTOPTIONS

S.A = [1 1 0 -3 0.5;
       0.1 -1 2 -8 0;
       [0.1 -1 2 -8 0]*2-1];
S.b = [2;3;3*2-1];
S.pB = randn(3);
S.Ae = randn(1,5);
S.be = rand(1);
S.pE = randn(1,3);
S.f = [1;-2;0;0;0.3];


% problem
problem = Opt(S);
r = problem.solve;

if r.exitflag~=MPTOPTIONS.INFEASIBLE
    error('Must be infeasible here.');
end

end