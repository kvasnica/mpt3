function test_enumplcp_02
% compares ENUMPLCP solution versus PLCP solver on a problem with 5 parameters an 30
% inequality constraints
%


% prediction horizon (=number of optimization variables in the dense
% formulation of MPC)
N = 2;

% random system with n states
n = 6;

%% generate a random system
r = poly(randn(1, n));
n = length(r)-1;
s = c2d(ss(tf(1, r)), 1);
sysStruct.A = s.A;
sysStruct.B = s.B;
sysStruct.C = s.C;
sysStruct.D = s.D;
sysStruct.umax = 1;
sysStruct.umin = -1;
sysStruct.xmax = 10*ones(n, 1);
sysStruct.xmin = -10*ones(n, 1);
probStruct.Q = eye(size(s.A));
probStruct.P_N = probStruct.Q;
probStruct.R = 1;
probStruct.N = N;
probStruct.norm = 2;
probStruct.Tconstraint = 0;
probStruct.subopt_lev = 0;

%% create a dense MPC formulation
if false
    % use native MPT3 interface
    model = mpt_import(sysStruct, probStruct);
    mpc = MPCController(model, probStruct.N);
    Y = mpc.toYALMIP();
    pqp = Opt(Y.constraints, Y.objective, Y.internal.parameters, Y.variables.u(:));
else
    % alternative via mpt_constructMatrices():
    M = mpt_constructMatrices(sysStruct, probStruct);
    problem = Opt(M);
end

problem.solver='PLCP';
res1 = problem.solve;

problem.solver='ENUMPLCP';
res2 = problem.solve;


% analyse the solutions

% identify which regions are missing
list=zeros(1,res1.xopt.Num);
lc = list;
r =  list;
for i=1:res1.xopt.Num
    % get point inside the set
    xc = res1.xopt.Set(i).Internal.ChebyData.x;
    r(i) = res1.xopt.Set(i).Internal.ChebyData.r;
    
    % find corresponding set in the second solution
    [isin, inwhich, closest]= res2.xopt.contains(xc);
    if isin
        list(i) = inwhich(1);
    else
        lc(i) = closest;        
    end
end

% check the radious of the inscribed ball inside the missing regions
idm = find(lc);
if any(r(idm)>1e-4)
    error('The radius of the missing regions exceeds tolerance 1e-4.')
end

end