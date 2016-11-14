function test_plcp_16_pass
%
% infeasible mplp
%

global MPTOPTIONS

S.A = randn(26,4);
S.b = randn(26,1);
S.pB = randn(26,3);

S.pF = randn(4,3);
S.f = randn(4,1);

problem = Opt(S);

r=problem.solve;

if r.exitflag ~= MPTOPTIONS.INFEASIBLE
    error('Must be infeasible here.');
end

end
