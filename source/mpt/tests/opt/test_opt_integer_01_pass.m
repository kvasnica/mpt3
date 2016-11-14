function test_opt_integer_01_pass
%
% represent integer variables as binary and verify map integer=T*binary+t
%
global MPTOPTIONS

m = 15; n = 3; d = 2;
S.A = randn(m,n);
S.b = 3*rand(m,1);
S.pB = randn(m,d);
S.f = randn(n,1);
S.pF = randn(n,d);
S.Ath=[eye(2);-eye(2)]; 
S.bth=[5;5;3;3];

% assume now that some variables are integers
S.vartype = 'CIC';

P = Polyhedron(S.Ath,S.bth);
th = P.chebyCenter.x;
bn = S.b+S.pB*th;
fn = S.f+S.pF*th;
% formulate problem with integer variables
prb_integer = Opt('A',S.A,'b',bn,'f',fn,'vartype',S.vartype);
res = prb_integer.solve;

% find feasible MILP
while res.exitflag~=MPTOPTIONS.OK
    
    S.A = randn(m,n);
    S.b = 3*rand(m,1);
    S.pB = randn(m,d);
    S.f = randn(n,1);
    S.pF = randn(n,d);

    bn = S.b+S.pB*th;
    fn = S.f+S.pF*th;
    % formulate problem with integer variables
    prb_integer = Opt('A',S.A,'b',bn,'f',fn,'vartype',S.vartype);
    res = prb_integer.solve;
    
end


% extract integer variables
ind_i = find(S.vartype=='I');
ind_c = find(S.vartype=='C');

% formulate problem
problem = Opt(S);

% check that binary formulation corresponds to integer formulation by
% solving MILP for all samples from the parameter space
x = P.grid(5);

T = problem.Internal.T;
t = problem.Internal.t;
vartype = ['CC',repmat('B',1,size(T,2))];
for i=1:size(x,1)
    th = x(i,:)';
    bn = S.b+S.pB*th;
    fn = S.f+S.pF*th;
    % formulate problem with integer variables
    prb_integer = Opt('A',S.A,'b',bn,'f',fn,'vartype',S.vartype);
    % formulate problem with binary variables    
    prb_binary = Opt('A',[S.A(:,ind_c) S.A(:,ind_i)*T],'c',fn(ind_i)*t,...
        'b',bn-S.A(:,ind_i)*t,'f',[fn(ind_c);fn(ind_i)*T'],...
        'vartype',vartype);

    % integer solution 
    r1 = prb_integer.solve;
    
    % binary solution
    r2 = prb_binary.solve;
    
    % recover integer variable
    xB = r2.xopt(3:end);
    xI = T*xB+t;
    xopt = zeros(n,1);
    xopt(ind_i) = xI;
    xopt(ind_c) = r2.xopt(1:2);
    
    % compare solutions
    if r1.exitflag==MPTOPTIONS.OK
        if norm(r1.xopt-xopt,Inf)>MPTOPTIONS.abs_tol
            error('Error in the binary representation.');
        end
    end
end


end
