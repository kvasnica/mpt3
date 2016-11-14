function test_opt_qp2lcp_26_pass
%
% mpMILP with 1 integer, 4 continous variables, 1 parameter
% 
% - subrank of inequality constraints matrix is lower than number of
% continuous variables

global MPTOPTIONS

load data_opt_qp2lcp_26

[m,n] = size(S.A);
d = size(S.Ath,2);

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
    T.pE = [S.pE; zeros(ni,d)];

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

% solution is infeasible (no regions)
if res.exitflag~=MPTOPTIONS.INFEASIBLE
    error('Should be infeasible.');
end
if sum([PU.Num])~=res.xopt.Num
    error('Zero regions are expected.');
end

end