function test_opt_integer_02_pass
%
% represent integer variables as binary and verify map integer=T*binary+t
% Wrong solution returned from the MILP solver.
%
global MPTOPTIONS
load data_milp_integer_01

% extract integer variables
ind_i = find(S.vartype=='I');
ind_c = find(S.vartype=='C');

% formulate problem
problem = Opt(S);

% check that binary formulation corresponds to integer formulation by
% solving MILP for all samples from the parameter space
P = Polyhedron(S.Ath,S.bth);
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
    xopt = zeros(3,1);
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
