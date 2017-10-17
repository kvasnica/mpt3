function test_enum_pqp_11
% degenerate pQP must not generate duplicit regions

load degenerate_pqp1.mat

SLV.mpqp.options.solver = 'plcp';
pqp0 = Opt('H',H,'pF',F,'f',f,'Y',Y,'C',...
    C,'c',c,'A',A,'b',b,'pB',B,'lb',lb,'ub',ub,...
    'Ath',Ath,'bth',bth,'vartype',SLV.mpqp.options.vartype,...
    'solver',SLV.mpqp.options.solver);
sol0 = pqp0.solve();
assert(sol0.xopt.Num==155); % 155 regions for mpqp and plcp

SLV.mpqp.options.solver = 'rlenumpqp';
pqp = Opt('H',H,'pF',F,'f',f,'Y',Y,'C',...
    C,'c',c,'A',A,'b',b,'pB',B,'lb',lb,'ub',ub,...
    'Ath',Ath,'bth',bth,'vartype',SLV.mpqp.options.vartype,...
    'solver',SLV.mpqp.options.solver);
sol = pqp.solve();
assert(length(unique(sol.xopt.Set))==155); % if not, we didn't include Ath*x<=bth bounds correctly
assert(sol.xopt.Num==155); % 155 regions for mpqp and plcp, more if we have duplicities

SLV.mpqp.options.solver = 'enumpqp';
pqp2 = Opt('H',H,'pF',F,'f',f,'Y',Y,'C',...
    C,'c',c,'A',A,'b',b,'pB',B,'lb',lb,'ub',ub,...
    'Ath',Ath,'bth',bth,'vartype',SLV.mpqp.options.vartype,...
    'solver',SLV.mpqp.options.solver);
sol2 = pqp.solve();
assert(length(unique(sol2.xopt.Set))==155); % if not, we didn't include Ath*x<=bth bounds correctly
assert(sol2.xopt.Num==155); % 155 regions for mpqp and plcp, more if we have duplicities


end
