function test_opt_qp2lcp_03_pass
%
% qp2lcp without redundancy elimination
%

global MPTOPTIONS

S.A=[  1.8048      0.65089;
      -2.3345      0.34068;
     -0.20446      0.13268;
      0.29604     -0.23329;
      0.44663      0.41649];
S.b = ones(5,1);
S.Ae = [0.64486     -0.28637];
S.be =  0.65702;
S.f = [1;0];
S.H = [1e-13 0; 0 0];
S.lb = [-10;-10];
S.ub = [10;10];

% true solution
res = mpt_solve(S);

% check if the solution is the same when solving LCP
problem = Opt(S);
problem.qp2lcp(false); %no simplification

rn=problem.solve;
x = problem.recover.uX*[rn.lambda;rn.xopt]+problem.recover.uTh;

% since there are multiple solutions, we compare only objective function
if norm(res.xopt-x,1)>MPTOPTIONS.rel_tol
    error('QP2LCP failed.');
end




end