function test_opt_qp2lcp_07_pass
%
% parametric qp2lcp, test if solution holds with QP
%

global MPTOPTIONS


S.A = [
  80.2 -9.11 8.7 0.4;
  0.1 -100000 -45 0.6;
  -90 0.56 -15.9 0.889;
  112.5 -54.6 -783.56 -556.9;
  0.1 -0.001 0.68 123;
  0 -89.9 12.8 -445.990];
S.b = [-3.4; 0.1; -9.4; 5.5; 23456.134; 70];
S.pB=[eye(2);-3*eye(2); randn(2)];
S.f = [1; -1; 0; 0];
S.H = diag(5*ones(4,1));
S.Ath = [eye(2);-eye(2)];
S.bth = 100*ones(4,1);

% solution
problem = Opt(S);
r = problem.solve;

% check if the solution is the same when solving QP
for i=1:r.xopt.Num
      xc = chebyCenter(r.xopt.Set(i));
      p.A = S.A;
      p.b = S.b + S.pB*xc.x;
      p.f = S.f;
      p.H = S.H;
      
      xopt=feval(r.xopt.Set(i),xc.x,'primal');

      res = mpt_solve(p);
      nr = norm(xopt-res.xopt,1);
      if nr>MPTOPTIONS.rel_tol
          error('Wrong MPQP solution, the difference is %f!',nr);
      end
      
      % check objective function
      obj=feval(r.xopt.Set(i),xc.x,'obj');
      no = norm(res.obj-obj,Inf);
      if no>MPTOPTIONS.rel_tol
          error('Objective value does not hold, the difference is %f.',no);
      end

      % check multipliers
      lineq=feval(r.xopt.Set(i),xc.x,'dual-ineqlin');
      n1 = norm(res.lambda.ineqlin-lineq,Inf);
      if n1>MPTOPTIONS.rel_tol
          error('Mulitpliers for inequality do not hold, the difference is %f.',n1);
      end
      
      
end


end