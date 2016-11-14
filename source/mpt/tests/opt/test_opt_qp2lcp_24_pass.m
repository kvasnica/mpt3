function test_opt_qp2lcp_24_pass
%
% mpMILP with 2 binaries, 7 continous variables, 1 parameter
% 
% - subrank of inequality constraints matrix is highre than number of
% continuous variables
% - equality constraints

global MPTOPTIONS

load data_opt_qp2lcp_24
[m,n] = size(S.A);
d = size(S.pB,2);
ind_b = find(S.vartype=='B');
nb = numel(ind_b);

Ae = zeros(nb,n);
Ae(:,ind_b) = eye(nb);

% solve for all possible combinations of binary variables
c=dec2bin(0:2^nb-1);
ncomb = size(c,1);
PU(ncomb,1) = PolyUnion;
for i=1:ncomb
    % pick a combination
    be = str2num(c(i,:)');
    
    % case
    cprb = Opt('f',S.f,'A',S.A,'b',S.b,'pB',S.pB,'lb',S.lb,'ub',S.ub,...
        'Ae',[S.Ae;Ae],'be',[S.be; be],'pE',[S.pE; zeros(nb,d)],...
        'pF',S.pF,'Ath',S.Ath,'bth',S.bth,'solver','mplp');
    s0 = cprb.solve;
        
    % MILP solution
    PU(i) = s0.xopt;
    
end

% transform to LCP and solve using enumerative PLCP solver
S.solver = 'enumplcp';
problem = Opt(S);
res = problem.solve;

% compare solutions
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