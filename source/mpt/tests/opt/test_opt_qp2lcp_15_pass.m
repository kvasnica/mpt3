function test_opt_qp2lcp_15_pass
%
% parametric qp2lcp, test if solution holds with QP
%
global MPTOPTIONS

% load test data
load test_dualLP_01

% true solution
%d.solver = 'cdd';
%res = mpt_solve(d);

d.ub = zeros(98,1);
problem = Opt(d);

% should be infeasible
problem.qp2lcp;

r =problem.solve;
if r.exitflag~=MPTOPTIONS.INFEASIBLE
    error('should beinfeasible');
end

end