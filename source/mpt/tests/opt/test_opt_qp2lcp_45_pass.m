function test_opt_qp2lcp_45_pass
%
% mpMIQP with 1 integer, 2 binaries,  5 continous variables, 2 parameters
% 
% - subrank of inequality constraints matrix is higher than number of
% continuous variables
% - equality constraints
% - inequality constraints 
% - lower/upper bounds

global MPTOPTIONS

load data_opt_qp2lcp_45

% solve original problem for all values of integer
problem = Opt(S);
ind_i = find(problem.vartype=='I');
ni = nnz(ind_i);
ind_b = find(problem.vartype=='B');
nb = nnz(ind_b);

lbi = sign(problem.Internal.lb(ind_i)).*(floor(abs(problem.Internal.lb(ind_i))));
ubi = sign(problem.Internal.ub(ind_i)).*(floor(abs(problem.Internal.ub(ind_i))));
range = lbi:ubi;

% for each integer create one combination of binaries
cb=dec2bin(0:2^nb-1);
ncb = size(cb,1);
T = S;
E = zeros(ni+nb,problem.n);
E(1:ni,ind_i) = eye(ni);
E(ni+1:ni+nb,ind_b) = eye(nb);
T.Ae = [S.Ae;E];
T.vartype = repmat('C',1,problem.n);
T.solver = 'mpqp';

% formulate problem and solve
PU(numel(range)*size(cb,1),1) = PolyUnion;
for i=1:numel(range)
    for j=1:ncb
        % pick a value
        T.be = [S.be; range(i); str2num(cb(j,:)')];
        T.pE = [S.pE; zeros(ni+nb,problem.d)];
        
        % case
        cprb = Opt(T);
        s1 = cprb.solve;
        
        % solution
        PU((i-1)*ncb+j) = s1.xopt;
    end
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
            error('The solutions do not hold.');
        end
               
        % solve non-parametrically and compare optima
        R.b = S.b+S.pB*th;
        R.be = S.be+S.pE*th;
        R.f = S.f + S.pF*th;
        r = mpt_solve(R);
        
        % take minimum out of multiple functions
        x = res.xopt.feval(th,'primal','tiebreak','obj');
        obj = res.xopt.feval(th,'obj','tiebreak','obj');
        lam_u = res.xopt.feval(th,'dual-upper','tiebreak','obj');
        lam_l = res.xopt.feval(th,'dual-lower','tiebreak','obj');
        lam_eq = res.xopt.feval(th,'dual-eqlin','tiebreak','obj');
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
        if ~isempty(r.lambda.eqlin)
            if norm(lam_eq-r.lambda.eqlin,Inf)>MPTOPTIONS.abs_tol
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