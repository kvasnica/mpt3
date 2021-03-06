function test_mpqp_3D_NN15(solver)
%
% 3D case NN15 from Compleib library
%

fname = mfilename;
check_PQPsolvers;

 A=[0,1,0;-79.285,-0.113,0;28.564,0.041,0];
 B=[0,0;0.041,-0.0047;-0.03,-0.0016];
 C=[0,0,1;1,0,0];
 
 D = zeros(2);
 
 % continuous system
 csys = ss(A,B,C,D);

 % discrete system with low sampling time
 dsys = c2d(csys,0.1);

 % extract data for MPT
 sysStruct = mpt_sys(dsys);
 sysStruct.xmin = 5*[-1;-1;-1];
 sysStruct.xmax = 5*[1;1;1];
 sysStruct.umin = 3*[-1;-1];
 sysStruct.umax = 4*[1;1];
 
 % formulate problem
 probStruct.norm = 2;
 probStruct.N = 2;
 probStruct.subopt_lev = 0;
 probStruct.Q = 5*eye(3);
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
 p = Pf.grid(50);
    
 % for any point in the grid find the appropriate region
 for j=1:size(p,1)
     isin = isInside(res.xopt.Set,p(j,:)');
     
     if ~isin
         error('There is a hole in this solution!');
     end
 end

end