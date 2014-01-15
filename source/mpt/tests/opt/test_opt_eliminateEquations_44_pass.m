function test_opt_eliminateEquations_44_pass
%
% parametric MILP with 1 integer, 2 binaries and 1 parameter
% 


global MPTOPTIONS

m = 5; n = 12; me = 8; d = 1;
S.A = randn(m,n);
S.b = 5*rand(m,1);
S.pB = randn(m,d);
S.f = randn(n,1);
S.pF = randn(n,d);
S.Ae = 8*randn(me,n);
S.be = randn(me,1);
S.pE = randn(me,d);
S.ub = 4*ones(n,1);
S.lb = -2*ones(n,1);
S.Ath = [eye(d);-eye(d)];
S.bth = [3*ones(d,1); 2*ones(d,1)];
S.vartype = 'CCCCICBCCBCC';

% solve original problem for all values of integer and binaries
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
[nc2,nb2] = size(cb);
T = S;
E = zeros(ni+nb,problem.n);
E(1:ni,ind_i) = eye(ni);
E(ni+1:ni+nb,ind_b) = eye(nb);
T.Ae = [S.Ae;E];
T.vartype = repmat('C',1,problem.n);
% formulate problem and solve
PU(numel(range)*size(cb,1),1) = PolyUnion;
for i=1:numel(range)
    for j=1:nc2
        % pick a value
        T.be = [S.be; range(i); str2num(cb(j,:)')];
        T.pE = [S.pE; zeros(ni+nb,d)];
        
        % case
        cprb = Opt(T);
        s1 = cprb.solve;
        
        % MIQP solution
        PU((i-1)*nc2+j) = s1.xopt;
    end
end

% solve reduced problem for all combinations of binary variables
problem.eliminateEquations;

% solve for all possible combinations of integer + binary variables
c1=dec2bin(range-problem.Internal.t);
[nc1,nb1] = size(c1);
Ae = zeros(nb1+nb2,problem.n);
Ae(1:nb1+nb2,1:nb1+nb2) = eye(nb1+nb2);
pE = zeros(nb1+nb2,d);
% formulate problem and solve
PUn(nc1*nc2,1) = PolyUnion;
for i=1:nc1
    % pick a combination
    for j=1:nc2
        be = [str2num(cb(j,:)');str2num(c1(i,:)');];
        cprb = Opt('H',problem.H,'f',problem.f,'pF',problem.pF,...
            'A',problem.A,'b',problem.b,'pB',problem.pB,...
            'Ae',Ae,'be',be,'pE',pE,'Ath',problem.Ath,'bth',problem.bth,...
            'lb',problem.lb,'ub',problem.ub);
        
        % solve
        s0 = cprb.solve;
        % MIQP solution
        PUn((i-1)*nc2+j) = s0.xopt;
    end
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