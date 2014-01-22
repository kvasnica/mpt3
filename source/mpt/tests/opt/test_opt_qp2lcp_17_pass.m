function test_opt_qp2lcp_17_pass
%
% mpMIQP with 2 binaries, 2 continous variables, 2 parameters
% 
% - subrank of inequality constraints matrix is lower than number of
% continuous variables
% - no equalities

global MPTOPTIONS

% m = 1; n = 4; d = 2;
% S.H = diag(rand(n,1));
% S.A = randn(m,n);
% S.b = 3*rand(m,1);
% S.pB = randn(m,d);
% S.f = randn(n,1);
% S.pF = randn(n,d);
% S.lb = [];%zeros(n,1);
% S.Ath=[eye(2);-eye(2)]; 
% S.bth=[5;5;3;3];
% S.vartype = 'BBCC';

load data_opt_qp2lcp_17

[m,n] = size(S.A);
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
    cprb = Opt('H',S.H,'f',S.f,'A',S.A,'b',S.b,'pB',S.pB,'lb',S.lb,...
        'Ae',Ae,'be',be,'pF',S.pF,'Ath',S.Ath,'bth',S.bth,'solver','mpqp');
    s0 = cprb.solve;
        
    % MIQP solution
    PU(i) = s0.xopt;
    
end

% transform to LCP and solve using enumerative PLCP solver
S.solver = 'enumplcp';
problem = Opt(S);
res = problem.solve;

% compare solutions
R.H = S.H;
R.A = S.A;
R.vartype = S.vartype;
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
            error('The MIQP solutions do not hold.');
        end
               
        % solve non-parametrically and compare optima
        R.b = S.b+S.pB*th;
        R.f = S.f+S.pF*th;
        r = mpt_solve(R);
        
        % take minimum out of multiple functions
        x = res.xopt.feval(th,'primal','tiebreak','obj');
        obj = res.xopt.feval(th,'obj','tiebreak','obj');
        lam_ineq = res.xopt.feval(th,'dual-ineqlin','tiebreak','obj');
        
        if norm(x-r.xopt,Inf)>MPTOPTIONS.abs_tol
            error('Primal solution does not hold.');
        end
        if norm(obj-r.obj,Inf)>MPTOPTIONS.abs_tol
            error('Objective does not hold.');
        end
        if norm(lam_ineq-r.lambda.ineqlin,Inf)>MPTOPTIONS.abs_tol
            error('Lagrange multipliers do not hold.');
        end
        
    end
end

end