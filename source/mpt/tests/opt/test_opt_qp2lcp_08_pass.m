function test_opt_qp2lcp_08_pass
%
% parametric qp2lcp, test if solution holds with QP
%

% load test data
load test_mpqp_03_dat

% solution
problem = Opt(S);
r = problem.solve;

% check if the solution is the same when solving QP
for i=1:r.xopt.Num
      xc = chebyCenter(r.xopt.Set(i));
      p.A = S.A;
      p.b = S.b + S.pB*xc.x;
      p.f = S.f + S.pF*xc.x;
      p.H = S.H;
      p.lb = S.lb;
      
      xopt=feval(r.xopt.Set(i),xc.x,'primal');

      rn = mpt_solve(p);
      nr = norm(xopt-rn.xopt,Inf);
      if nr>1e-3
          error('Wrong PLCP solution, the difference is %f!',nr);
      end
      
      % check objective function
      obj=feval(r.xopt.Set(i),xc.x,'obj');
      no = norm(rn.obj-obj,Inf);
      if no>1e-4
          error('Objective value does not hold, the difference is %f.',no);
      end

      % check multipliers
      lineq=feval(r.xopt.Set(i),xc.x,'dual-ineqlin');
      n1 = norm(rn.lambda.ineqlin-lineq,Inf);
      if n1>1e-4
          error('Mulitpliers for inequality do not hold, the difference is %f.',n1);
      end

end


end