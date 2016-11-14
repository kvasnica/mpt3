function test_opt_eliminateEquations_40_pass
%
% parametric MIQP with 1 integer, 1 parameter
% 


global MPTOPTIONS

load data_opt_eliminateEquations_40

d = size(S.pB,2);
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
        
    % MIQP solution
    PU(i) = s1.xopt;
end

% solve reduced problem for all combinations of binary variables
problem.eliminateEquations;
ind_b = find(problem.vartype=='B');
nb = nnz(ind_b);

% solve for all possible combinations of binary variables
c=dec2bin(range-problem.Internal.t);
ncomb = size(c,1);
PUn(ncomb,1) = PolyUnion;
Ae = zeros(nb,problem.n);
Ae(:,ind_b) = eye(nb);
pE = zeros(nb,d);
R.vartype = repmat('C',1,problem.n);
% formulate problem and solve
PUn(ncomb,1) = PolyUnion;
for i=1:ncomb
    % pick a combination
    be = str2num(c(i,:)');
    cprb = Opt('H',problem.H,'f',problem.f,'pF',problem.pF,...
        'A',problem.A,'b',problem.b,'pB',problem.pB,...
        'Ae',Ae,'be',be,'pE',pE,'Ath',problem.Ath,'bth',problem.bth,...
        'lb',problem.lb,'ub',problem.ub);
    
    % solve
    s0 = cprb.solve;
    PUn(i) = s0.xopt;
    
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