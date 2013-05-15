function test_opt_eliminateEquations_06_pass
%
% added equalities on the parameter
%
global MPTOPTIONS

S.A = randn(10,14);
S.b = ones(10,1);
S.pB = randn(10,2);
S.Ae = randn(6,14);
S.be = rand(6,1);
S.pE = randn(6,2);
S.f = ones(14,1);
S.lb = -10*ones(14,1);
S.ub = 10*ones(14,1);
S.solver = 'plcp';

% construct problem
problem = Opt(S);

% solve problem
r = problem.solve;

% solve using MPLP
S.solver = 'mplp';
problem = Opt(S);
res = problem.solve;

if res.xopt.Num~=r.xopt.Num
    error('The number of regions does not hold.');
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

    if norm(x1-x2,1)>MPTOPTIONS.rel_tol
        error('explicit solutions are not equal!');
    end
    
    % evaluate objective function
    obj1 = feval(res.xopt.Set(i),xc.x,'obj');
    obj2 = feval(r.xopt.Set(ireg),xc.x,'obj');
    
    if norm(obj1-obj2,1)>MPTOPTIONS.rel_tol
        error('objective values do not hold.');
    end
    
    % compare multipliers
    Sn.A = S.A;
    Sn.b = S.b + S.pB*xc.x;
    Sn.Ae = S.Ae;
    Sn.be = S.be + S.pE*xc.x;
    Sn.f = S.f;
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
