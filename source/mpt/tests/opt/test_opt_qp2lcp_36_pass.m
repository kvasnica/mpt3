function test_opt_qp2lcp_36_pass
%
% mpMILP with 1 integer, 2 binaries,  4 continous variables, 1 parameter
% 
% - subrank of inequality constraints matrix is smaller than number of
% continuous variables
% - equality constraints
% - feasibility problem

global MPTOPTIONS

load data_opt_qp2lcp_36

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
T.solver = 'mplp';
E = zeros(ni+nb,problem.n);
E(1:ni,ind_i) = eye(ni);
E(ni+1:ni+nb,ind_b) = eye(nb);
T.Ae = [S.Ae;E];
T.vartype = repmat('C',1,problem.n);

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
R.A = S.A;
R.f = S.f;
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
        
        % check constraints
        if any(S.A*x1>S.b+S.pB*th+MPTOPTIONS.abs_tol)
            error('mplp solution does not satisfy constraints.');
        end
        for k=1:size(xopt,2)
            if any(S.A*xopt(:,k)>S.b+S.pB*th+MPTOPTIONS.abs_tol)
                error('mplp solution does not satisfy constraints.');
            end
        end
        
    end
end

end