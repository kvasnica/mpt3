function test_opt_eliminateEquations_08_pass
%
% added equalities on the parameter + quadratic objective
% 3 parameters
%
global MPTOPTIONS

S.A = randn(10,4);
S.b = ones(10,1);
S.pB = randn(10,3);
S.Ae = randn(2,4);
S.be = rand(2,1);
S.pE = randn(2,3);
S.f = ones(4,1);
S.pF = randn(4,3);
Q=randn(4);
S.H = Q'*Q/sqrt(2);
S.lb = -10*ones(4,1);
S.ub = 10*ones(4,1);
S.solver = 'plcp';

% construct problem
problem = Opt(S);

% solve problem
r = problem.solve;

% solve using MPQP
S.solver = 'mpqp';
problem = Opt(S);
res = problem.solve;

if res.xopt.Num>r.xopt.Num
    
    % for each region solve LP to test if the solution is the same
    %active1=zeros(r.regions.numP,problem.m);
    for i=1:r.xopt.Num
        
        xc = chebyCenter(r.xopt.Set(i));
        P.A = S.A;
        P.b = S.b + S.pB*xc.x;
        P.Ae = S.Ae;
        P.be = S.be + S.pE*xc.x;
        P.f = S.f + S.pF*xc.x;
        P.H = S.H;
        P.lb = S.lb;
        P.ub = S.ub;
        
        rn= mpt_solve(P);
        
        xopt=feval(r.xopt.Set(i),xc.x,'primal');
        obj = feval(r.xopt.Set(i),xc.x,'obj');        
        
        % solution might not be the same
        fprintf('region:%d, difference in the PLCP solution %f.\n',i,norm(rn.xopt-xopt,1));
        fprintf('region:%d, difference in the PLCP objective value %f.\n',i,rn.obj-obj);
        
        
        % check active constraints
        %active1(i,:) = ( S.A*rn.xopt >= S.b-MPTOPTIONS.rel_tol);
        
        
    end
    
    % for each region solve LP to test if the solution is the same
    active2=zeros(res.xopt.Num,problem.m);
    for i=1:res.xopt.Num
        
        xc = chebyCenter(res.xopt.Set(i));
        P.A = S.A;
        P.b = S.b + S.pB*xc.x;
        P.Ae = S.Ae;
        P.be = S.be + S.pE*xc.x;
        P.f = S.f + S.pF*xc.x;
        P.H = S.H;
        P.lb = S.lb;
        P.ub = S.ub;
        
        rn= mpt_solve(P);
        
        xopt=feval(res.xopt.Set(i),xc.x,'primal');
        obj = feval(res.xopt.Set(i),xc.x,'obj');
        
        % solution might not be the same
        fprintf('region:%d, difference in the MPQP solution %f.\n',i,norm(rn.xopt-xopt,1));
        fprintf('region:%d, difference in the MPQP objective value %f.\n',i,rn.obj-obj)
        
        % check active constraints
        active2(i,:) = ( S.A*rn.xopt >= S.b-MPTOPTIONS.rel_tol);
        
        
    end

    % find the region which does not hold
    list = zeros(res.xopt.Num,2);
    for i=1:res.xopt.Num
        % find a point inside region from MPQP
        x = chebyCenter(res.xopt.Set(i));
        list(i,1) = i;
        
        % find index of region from PLCP
        index=find_region(x.x,r.xopt.Set,r.xopt.Internal.adj_list);
        
        if ~isempty(index)
            list(i,2) = index;
        end
        
    end
    
    
    
    error('The number of regions does not hold.');
else
     % do gridding
    Pf = Polyhedron('H',double(res.mpqpsol.Phard));
    % grid the feasible space very densely
    p = Pf.grid(50);
    
    % for any point in the grid find the appropriate region
    for j=1:size(p,1)
        isin = isInside(r.xopt.Set,p(j,:)');
        
        if ~isin
            error('There is a hole in this solution!');
        end
    end
end

% check solution
for i=1:res.xopt.Num
    % get some point inside Pn
    xc = chebyCenter(res.xopt.Set(i));
    % region index
    ireg = find_region(xc.x,r.xopt.Set,r.xopt.Internal.adj_list);
    % evaluate solutions
    x1 = feval(res.xopt.Set(i),xc.x,'primal');
    x2 = feval(r.xopt.Set(ireg),xc.x,'primal');

    if norm(x1-x2,Inf)>MPTOPTIONS.rel_tol
        error('explicit solutions are not equal!');
    end
    
    % evaluate objective function
    obj1 = feval(res.xopt.Set(i),xc.x,'obj');
    obj2 = feval(r.xopt.Set(ireg),xc.x,'obj');
    
    if norm(obj1-obj2,Inf)>MPTOPTIONS.rel_tol
        error('objective values do not hold.');
    end
    
    % compare multipliers
    Sn.A = S.A;
    Sn.b = S.b + S.pB*xc.x;
    Sn.Ae = S.Ae;
    Sn.be = S.be + S.pE*xc.x;
    Sn.f = S.f + S.pF*xc.x;
    Sn.H = S.H;
    Sn.lb = S.lb;
    Sn.ub = S.ub;
    
    rn = mpt_solve(Sn);
    
    % ineqlin
    lineq = feval(r.xopt.Set(ireg),xc.x,'dual-ineqlin');
    if norm(rn.lambda.ineqlin-lineq,Inf)>MPTOPTIONS.rel_tol
        error('Lagrange multipliers for inequalities do not hold.');
    end

    leq = feval(r.xopt.Set(ireg),xc.x,'dual-eqlin');
    if norm(rn.lambda.eqlin-leq,Inf)>MPTOPTIONS.rel_tol
        error('Lagrange multipliers for equalities do not hold.');
    end

    llb = feval(r.xopt.Set(ireg),xc.x,'dual-lower');
    if norm(rn.lambda.lower-llb,Inf)>MPTOPTIONS.rel_tol
        error('Lagrange multipliers for lower bounds do not hold.');
    end
    
    lub = feval(r.xopt.Set(ireg),xc.x,'dual-upper');
    if norm(rn.lambda.upper-lub,Inf)>MPTOPTIONS.rel_tol
        error('Lagrange multipliers for upper bounds do not hold.');
    end
    
    
end


end
