function test_mplp_4D_AC5(solver)
%
% 4D case AC5 from Compleib library
%

fname = mfilename;
check_PLPsolvers;

  A=[0.9801  0.0003 -0.0980  0.0038;
   -0.3868  0.9071  0.0471 -0.0008;
    0.1591 -0.0015  0.9691  0.0003;
   -0.0198  0.0958  0.0021  1      ];
  B=[-0.0001  0.0058; 0.0296  0.0153; 0.0012 -0.0908; 0.0015  0.0008];
  C=[1 0 0 0;0 0 0 1];

 D = zeros(2);

 % continuous system
 csys = ss(A,B,C,D);

 % discrete system with low sampling time
 dsys = c2d(csys,2);

 % extract data for MPT
 sysStruct = mpt_sys(dsys);
 sysStruct.xmin = 0.6*[-1.5;-2;-3;-2];
 sysStruct.xmax = 0.5*[1;2;3;1.2];
 sysStruct.umin = [-1;-1.2];
 sysStruct.umax = [1.1;1.4];
 
 % formulate problem
 probStruct.norm = 1;
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