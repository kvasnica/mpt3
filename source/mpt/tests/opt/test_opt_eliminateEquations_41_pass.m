function test_opt_eliminateEquations_41_pass
%
% parametric MILP with 1 integer and 2 parameters
% 


global MPTOPTIONS

m = 7; n = 10; me = 5; d = 2;
S.A = randn(m,n);
S.b = 2*rand(m,1);
S.pB = randn(m,d);
S.f = randn(n,1);
S.pF = randn(n,d);
S.Ae = 3*randn(me,n);
S.be = randn(me,1);
S.pE = randn(me,d);
S.ub = 7*ones(n,1);
S.lb = -4*ones(n,1);
S.Ath = [eye(d);-eye(d)];
S.bth = [2*ones(d,1); 4*ones(d,1)];
S.vartype = 'CCCCICCCCC';

% solve original problem for all values of integer and binaries
problem = Opt(S);
ind_i = find(problem.vartype=='I');
ni = nnz(ind_i);

lbi = sign(problem.Internal.lb(ind_i)).*(floor(abs(problem.Internal.lb(ind_i))));
ubi = sign(problem.Internal.ub(ind_i)).*(floor(abs(problem.Internal.ub(ind_i))));
range = lbi:ubi;

% for each integer create one combination of binaries
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

% solve reduced problem for all combinations of binary variables
problem.eliminateEquations;

% solve for all integers
c1=dec2bin(range-problem.Internal.t);
[nc,nb2] = size(c1);
Ae = zeros(nb2,problem.n);
Ae(:,1:nb2) = eye(nb2);
pE = zeros(nb2,d);
% formulate problem and solve
PUn(nc,1) = PolyUnion;
for i=1:nc
    % pick a combination
    be = str2num(c1(i,:)');
    cprb = Opt('H',problem.H,'f',problem.f,'pF',problem.pF,...
        'A',problem.A,'b',problem.b,'pB',problem.pB,...
        'Ae',Ae,'be',be,'pE',pE,'Ath',problem.Ath,'bth',problem.bth,...
        'lb',problem.lb,'ub',problem.ub);
    % solve
    s0 = cprb.solve;
    % solution
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
                % for LPs check the cost as well
                obj1 = PU(i).feval(th,'obj');
                obj2 = (S.pF*th+S.f)'*xopt;
                if norm(obj1-obj2,Inf)>MPTOPTIONS.abs_tol
                    error('The MILP solutions do not hold.');
                end
            end
            
        end
    end
end


end