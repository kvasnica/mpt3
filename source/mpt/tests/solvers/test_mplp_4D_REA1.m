function test_mplp_4D_REA1(solver)
%
% 4D case REA1 from Compleib library
%

 A=[1.38 -0.2077 6.715 -5.676;-0.5814 -4.29 0 0.675;1.067 4.273 -6.654 5.893;
    0.048 4.273 1.343 -2.104];
 B=[0 0;5.679 0;1.136 -3.146;1.136 0];
 C=[1 0 1 -1;0 1 0 0;0 0 1 -1];
 D = zeros(3,2);

 % continuous system
 csys = ss(A,B,C,D);

 % discrete system with low sampling time
 dsys = c2d(csys,0.05);

 % extract data for MPT
 sysStruct = mpt_sys(dsys);
 sysStruct.xmin = [-1.5;-2;-3;-2];
 sysStruct.xmax = [1;2;3;1.2];
 sysStruct.umin = 2*[-1;-2];
 sysStruct.umax = 5*[1;2];
 
 % formulate problem
 probStruct.norm = Inf;
 probStruct.N = 1;
 probStruct.subopt_lev = 0;
 probStruct.Q = eye(4);
 probStruct.R = eye(2);
 
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