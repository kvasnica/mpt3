function test_opt_qp2lcp_22_pass
%
% mpMILP with 2 binaries, 3 continous variables, 1 parameter
% 
% - subrank of inequality constraints matrix is smaller than number of
% continuous variables

global MPTOPTIONS

% m = 2; n = 5; d = 1; me = 0;
% S.A = randn(m,n);
% S.b = rand(m,1);
% S.pB = randn(m,d);
% S.f = zeros(n,1);
% S.pF = []; % no parameters in the cost because MPLP solver does not handle these
% S.Ae = 5*randn(me,n);
% S.be = randn(me,1);
% S.pE = randn(me,d);
% S.lb = [];
% S.ub = [];
% S.Ath=[eye(d);-eye(d)]; 
% S.bth=[15*ones(d,1);21*ones(d,1)];
% S.vartype = 'CBCBC';

load data_opt_qp2lcp_22

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
        
    % solution
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
        obj1 = PU(i).Set(j).feval(th,'obj');
        % evaluate the LCP solution
        obj2 = res.xopt.feval(th,'obj');
        
        for k=1:size(obj2,2)
           nt(k) = norm(obj1-obj2(:,k),Inf)>MPTOPTIONS.abs_tol; 
        end
        
        % all combinations must be equal, otherwise there is a mistake
        if any(nt)
            error('The MILP solutions do not hold.');
        end
         
        % check constraint satisfaction
        xopt = res.xopt.feval(th,'primal');
        for k=1:size(xopt,2)
            if (S.A*xopt(:,k)>S.b+S.pB*th+MPTOPTIONS.abs_tol)
                error('Constraints are not satisfied.');
            end
        end
        
    end
end

end