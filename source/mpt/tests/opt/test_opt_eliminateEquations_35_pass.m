function test_opt_eliminateEquations_35_pass
%
% mpMIQP with 2 binaries, 5 continous variables, 2 parameters
% 
% equalities on the parameter

global MPTOPTIONS

load data_opt_eliminateEquations_35

[m,n] = size(S.A);
d = size(S.pB,2);
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