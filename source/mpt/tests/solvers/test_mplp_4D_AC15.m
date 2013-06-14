function test_mplp_4D_AC15(solver)
%
% 4D case AC15 from Compleib library
%

fname = mfilename;
check_PLPsolvers;

  A=[-.037 .0123 .00055 -1;0 0 1 0;-6.37 0 -.23 .0618;1.25 0 .016 -.0457];
 B=[.00084 .000236;0 0;.08 .804;-.0862 -.0665];
 C=[0 1 0 0;0 0 1 0;0 0 0 1];
 D = zeros(3,2);

 % continuous system
 csys = ss(A,B,C,D);

 % discrete system with low sampling time
 dsys = c2d(csys,1);

 % extract data for MPT
 sysStruct = mpt_sys(dsys);
 sysStruct.xmin = [-1.5;-1.2;-1.3;-1.2];
 sysStruct.xmax = [1;1.2;1.3;1.2];
 sysStruct.umin = 4*[-1.3;-1.1];
 sysStruct.umax = 3.4*[1.1;1.2];
 
 % formulate problem
 probStruct.norm = Inf;
 probStruct.N = 1;
 probStruct.subopt_lev = 0;
 probStruct.Q = eye(4);
 probStruct.R = 0.5*eye(2);
 
 % get matrices
 M = mpt_constructMatrices(sysStruct,probStruct);
 
 % assign solver
 M.solver = solver;
 
 % construt problem
 problem = Opt(M);
 
 % solve parametric problem
 res = problem.solve;
 
 % compute a feasible set by lifting to th-x space
 A = [zeros(size(problem.Ath,1),problem.n), problem.Ath;
     -problem.pB, problem.A;
     zeros(problem.n,problem.d), eye(problem.n);
     zeros(problem.n,problem.d), -eye(problem.n)];
 b = [problem.bth; problem.b; problem.ub; -problem.lb];
 Ae = [-problem.pE, problem.Ae ];
 be = problem.be;
 P = Polyhedron('A',A,'b',b,'Ae',Ae,'be',be);
 % project back on theta space
 T = P.projection(1:problem.d,'mplp',solver);
 
 % intersect with theta constraints to get feasible space
 Q = Polyhedron(problem.Ath,problem.bth);
 Pf = intersect(T,Q);
 
 % grid the feasible space very densely 
 p = Pf.grid(30);
    
 % for any point in the grid find the appropriate region
 for j=1:size(p,1)
     isin = isInside(res.xopt.Set,p(j,:)');
     
     if ~isin
         error('There is a hole in this solution!');
     end
 end

end