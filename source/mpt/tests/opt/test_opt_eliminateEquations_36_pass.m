function test_opt_eliminateEquations_36_pass
%
% mpMIQP with 4 binaries, 6 continous variables, 1 parameter
% 
% equalities on the parameter + lower/upper bounds

global MPTOPTIONS

m = 23; n = 10; me=5; d=1;
S.A = randn(m,n);
S.b = 13*rand(m,1);
S.pB = randn(m,d);
Q = randn(n);
S.H = 0.5*(Q'*Q);
S.f = randn(n,1);
S.pF = randn(n,d);
S.Ae = 5*randn(me,n);
S.be = randn(me,1);
S.pE = randn(me,d);
S.Ath = [eye(d);-eye(d)];
S.bth = [12*ones(d,1);10*ones(d,1)];
S.ub = 5*ones(n,1);
S.lb = -4*ones(n,1);
S.vartype = 'BBCCBCCBCC';


ind_b = find(S.vartype=='B');
nb = nnz(ind_b);

% solve for all possible combinations of binary variables
c=dec2bin(0:2^nb-1);
ncomb = size(c,1);
PU(ncomb,1) = PolyUnion;
R = S;
E = zeros(nb,n);
E(:,ind_b) = eye(nb);
R.Ae = [S.Ae; E];
R.pE = [S.pE; zeros(nb,d)];
R.vartype = repmat('C',1,n);
% formulate problem and solve
for i=1:ncomb
    % pick a combination
    R.be = [S.be; str2num(c(i,:)')];

    % case
    cprb = Opt(R);
    s0 = cprb.solve;
        
    % MILP solution
    PU(i) = s0.xopt;
    
end

% eliminate equations and solve reduced problem
problem = Opt(S);
problem.eliminateEquations;


ind_bn = find(problem.vartype=='B');
nbn = nnz(ind_bn);

% solve for all possible combinations of binary variables
cn=dec2bin(0:2^nbn-1);
ncomb = size(cn,1);
PUn(ncomb,1) = PolyUnion;
T.H = problem.H;
T.f = problem.f;
T.pF = problem.pF;
T.A = problem.A;
T.b = problem.b;
T.pB = problem.pB;
T.Ath = problem.Ath;
T.bth = problem.bth;
T.lb = problem.lb;
T.ub = problem.ub;

E = zeros(nbn,problem.n);
E(:,ind_bn) = eye(nbn);
T.Ae = E;
T.vartype = repmat('C',1,problem.n);
% formulate problem and solve
for i=1:ncomb
    % pick a combination
    T.be = str2num(cn(i,:)');

    % case
    cprb = Opt(T);
    s1 = cprb.solve;
        
    % MILP solution
    PUn(i) = s1.xopt;
    
end


% compare solutions
for i=1:numel(PU)
    if PU(i).Num>0
        for j=1:PU(i).Num
            th = PU(i).Set(j).chebyCenter.x;
            % evaluate the optimal solution
            x1 = PU(i).feval(th,'primal');
            % evaluate the reduced solution
            x2 = PUn(i).feval(th,'primal');
            xopt = problem.recover.Y*x2 + problem.recover.th*[th;1];
            
            if norm(x1-xopt,Inf)>MPTOPTIONS.abs_tol
                error('The MIQP solutions do not hold.');
            end
            
        end
    end
end

end