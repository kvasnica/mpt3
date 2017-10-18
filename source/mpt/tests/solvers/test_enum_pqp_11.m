function test_enum_pqp_11
% degenerate pQP must not generate duplicit regions

load degenerate_pqp1.mat
nr = 155;% nr regions for mpqp and plcp

if false
    nu = size(A, 2);
    nx = size(B, 2);
    % bound the primal optimizer
    A = [A; eye(nu); -eye(nu)];
    b = [b; 100*ones(2*nu, 1)];
    B = [B; zeros(2*nu, nx)];
    % bound the parametric space
    A = [A; zeros(2*nx, nu)];
    B = [B; -eye(nx); eye(nx)];
    b = [b; 100*ones(2*nx, 1)];
end
if false
    % dimensionality reduction (third column of B is all zeros = x3 does
    % not contribute to constraints) - but the problem is still degenerate
    B = B(:, 1:2);
    F = F(:, 1:2);
    Y = Y(1:2, 1:2);
    C = C(1:2);
    Ath = [eye(2); -eye(2)];
    bth = 1.5*ones(4, 1);
    nr = 51;
end    

SLV.mpqp.options.solver = 'plcp';
pqp0 = Opt('H',H,'pF',F,'f',f,'Y',Y,'C',...
    C,'c',c,'A',A,'b',b,'pB',B,'lb',lb,'ub',ub,...
    'Ath',Ath,'bth',bth,'vartype',SLV.mpqp.options.vartype,...
    'solver',SLV.mpqp.options.solver);
tt=clock; sol0 = pqp0.solve(); etime(clock, tt)
assert(sol0.xopt.Num==nr); 

SLV.mpqp.options.solver = 'rlenumpqp';
pqp = Opt('H',H,'pF',F,'f',f,'Y',Y,'C',...
    C,'c',c,'A',A,'b',b,'pB',B,'lb',lb,'ub',ub,...
    'Ath',Ath,'bth',bth,'vartype',SLV.mpqp.options.vartype,...
    'solver',SLV.mpqp.options.solver);
tt=clock; sol = pqp.solve(); etime(clock, tt)
assert(length(unique(sol.xopt.Set))==nr); % if not, we didn't include Ath*x<=bth bounds correctly
assert(sol.xopt.Num==nr); % nr regions for mpqp and plcp, more if we have duplicities

SLV.mpqp.options.solver = 'enumpqp';
pqp2 = Opt('H',H,'pF',F,'f',f,'Y',Y,'C',...
    C,'c',c,'A',A,'b',b,'pB',B,'lb',lb,'ub',ub,...
    'Ath',Ath,'bth',bth,'vartype',SLV.mpqp.options.vartype,...
    'solver',SLV.mpqp.options.solver);
sol2 = pqp.solve();
assert(length(unique(sol2.xopt.Set))==nr); % if not, we didn't include Ath*x<=bth bounds correctly
assert(sol2.xopt.Num==nr); % nr regions for mpqp and plcp, more if we have duplicities


end
