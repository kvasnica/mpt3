function test_mplp_2D_NN2(solver)
%
% 2D case NN2 from Compleib library
%

 A=[0,1;-1,0];
 B=[0;1];
 C=[0,1];
 D = 0;

 % continuous system
 csys = ss(A,B,C,D);

 % discrete system
 dsys = c2d(csys,0.1);

 % extract data for MPT
 sysStruct = mpt_sys(dsys);
 sysStruct.ymin = -10;
 sysStruct.ymax = 10;
 sysStruct.umin = -1;
 sysStruct.umax = 1;
 
 % formulate problem
 probStruct.norm = Inf;
 probStruct.N = 6;
 probStruct.subopt_lev = 0;
 probStruct.Q = 2*eye(2);
 probStruct.R = 0.3;
 
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
 [x,y] = Pf.meshGrid(100);
 
 % get points inside the polytope Pf
 p=[x(:),y(:)];
 % delete NaN
 p(any(~isfinite(p),2),:)=[];
    
 % gridding is not exact, so we cut the points outside of feasible
 % domain
 ts = false(size(p,1),1);
 for k=1:size(p,1)
     ts(k) = any(Pf.H*[p(k,:),-1]'>0);
 end
 p(ts,:)=[];

    % for any point in the grid find the appropriate region 
    for j=1:size(p,1)
        isin = isInside(res.xopt.Set,p(j,:)');
        
        if ~isin
            error('There is a hole in this solution!');
        end
    end

end