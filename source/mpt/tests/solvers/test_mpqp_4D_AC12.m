function test_mpqp_4D_AC12(solver)
%
% 4D case AC5 from Compleib library
%

fname = mfilename;
check_PQPsolvers;

 A=[-0.0017, 0.0413,-5.3257,-9.7565;
    -0.0721,-0.3393,49.5146,-1.0097;
    -0.0008, 0.0138,-0.2032, 0.0009;
          0,      0,      1,      0];
 B=[ 0.2086,-0.0005,-0.0271;
     -0.0005, 0.2046, 0.0139;
     -0.0047, 0.0023, 0.1226;
          0,      0,      0];
 C=[      0,      0,57.2958,      0;
           0,      0,      0,57.2958;
      0.1045,-0.9945, 0.1375,51.5791;
     -0.0002, 0.0045,      0,      0];
 D = zeros(4,3);

 % continuous system
 csys = ss(A,B,C,D);

 % discrete system with low sampling time
 dsys = c2d(csys,1);

 % extract data for MPT
 sysStruct = mpt_sys(dsys);
 sysStruct.xmin = [-1.5;-1.2;-1.3;-1.2];
 sysStruct.xmax = [1;1.2;1.3;1.2];
 sysStruct.umin = [-1.3;-1.2;-1.1];
 sysStruct.umax = [1.1;1.4;1.2];
 
 % formulate problem
 probStruct.norm = 2;
 probStruct.N = 2;
 probStruct.subopt_lev = 0;
 probStruct.Q = eye(4);
 probStruct.R = 0.2*eye(3);
 
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