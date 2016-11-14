function test_opt_qp2lcp_01_pass
%
% rank of A is less than dimension
%
% this test is also on eliminateEquations
%

global MPTOPTIONS

S.f = [ -1    -1     0     0     0];
S.A = [  1     0     0     0     0;
         0     1     0     0     0];
S.b = [3;4];
S.Ae = [0.40362     -0.46555     -0.79321     -0.63101       -1.014;
        0.50357     -0.51586       2.6265      0.75508          1.3];
S.be = [-0.47267; -0.081472];

% true solution
res = mpt_solve(S);

% check if the solution is the same when solving LCP
problem = Opt(S);
problem.qp2lcp;

rn=problem.solve;
x = problem.recover.uX*[rn.lambda;rn.xopt]+problem.recover.uTh;

% since there are multiple solutions, we compare only objective function
if norm(res.obj-S.f*x,1)>MPTOPTIONS.rel_tol
    error('QP2LCP failed.');
end




end