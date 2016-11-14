function test_opt_qp2lcp_25_pass
%
% mpMILP with 1 integer, 11 continous variables, 1 parameter
% 
% - subrank of inequality constraints matrix is higher than number of
% continuous variables

global MPTOPTIONS

load data_opt_qp2lcp_25

% solve original problem for all values of integer
problem = Opt(S);
ind_i = find(problem.vartype=='I');
ni = nnz(ind_i);

lbi = sign(problem.Internal.lb(ind_i)).*(floor(abs(problem.Internal.lb(ind_i))));
ubi = sign(problem.Internal.ub(ind_i)).*(floor(abs(problem.Internal.ub(ind_i))));
range = lbi:ubi;

T = S;
E = zeros(ni,problem.n);
E(:,ind_i) = eye(ni);
T.Ae = [S.Ae;E];
T.vartype = repmat('C',1,problem.n);
% formulate problem and solve
PU(numel(range),1) = PolyUnion;
for i=1:numel(range)
    % pick a value
    T.be = [S.be; range(i)];
    T.pE = [S.pE; zeros(ni,problem.d)];

    % case
    cprb = Opt(T);
    s1 = cprb.solve;
        
    % solution
    PU(i) = s1.xopt;
end

% transform to LCP and solve using enumerative PLCP solver
S.solver = 'enumplcp';
problem = Opt(S);
res = problem.solve;

% compare solutions
R.H = S.H;
R.A = S.A;
R.f = S.f;
R.Ae = S.Ae;
R.vartype = S.vartype;
R.lb = S.lb;
R.ub = S.ub;
for i=1:numel(PU)
    for j=1:PU(i).Num
        th = PU(i).Set(j).chebyCenter.x;
        % evaluate the optimal solution
        x1 = PU(i).Set(j).feval(th,'primal');
        % evaluate the LCP solution
        xopt = res.xopt.feval(th,'primal');
        
        nt = true(1,size(xopt,2));
        for k=1:size(xopt,2)
           nt(k) = norm(x1-xopt(:,k),Inf)>MPTOPTIONS.abs_tol; 
        end
        
        % one combination must be equal, otherwise there is a mistake
        if all(nt)
            error('The MILP solutions do not hold.');
        end
               
        % solve non-parametrically and compare optima
        R.b = S.b+S.pB*th;
        R.be = S.be+S.pE*th;
        r = mpt_solve(R);
        
        % take minimum out of multiple functions
        x = res.xopt.feval(th,'primal','tiebreak','obj');
        obj = res.xopt.feval(th,'obj','tiebreak','obj');
        lam_u = res.xopt.feval(th,'dual-upper','tiebreak','obj');
        lam_l = res.xopt.feval(th,'dual-lower','tiebreak','obj');
        lam_ineq = res.xopt.feval(th,'dual-ineqlin','tiebreak','obj');
        
        if norm(x-r.xopt,Inf)>MPTOPTIONS.abs_tol
            error('Primal solution does not hold.');
        end
        if norm(obj-r.obj,Inf)>MPTOPTIONS.abs_tol
            error('Objective does not hold.');
        end
        if ~isempty(r.lambda.upper)
            if norm(lam_u-r.lambda.upper,Inf)>MPTOPTIONS.abs_tol
                error('Lagrange multipliers do not hold.');
            end
        end
        if ~isempty(r.lambda.lower)
            if norm(lam_l-r.lambda.lower,Inf)>MPTOPTIONS.abs_tol
                error('Lagrange multipliers do not hold.');
            end
        end
        if ~isempty(r.lambda.ineqlin)
            if norm(lam_ineq-r.lambda.ineqlin,Inf)>MPTOPTIONS.abs_tol
                error('Lagrange multipliers do not hold.');
            end
        end
        
    end
end

end