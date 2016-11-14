function test_opt_22_pass
%
% problem with Pfinal using LCP solver
%

load data_opt_test22

% used solver
options = mptopt;
qpsolver = options.qpsolver;

% set new solver
mptopt('qpsolver', 'lcp');
res_lcp = Opt(S).solve();

mptopt('qpsolver', 'quadprog');
res_quadprog = Opt(S).solve();

% put old solver back
mptopt('qpsolver',qpsolver);

plot([res_lcp.mpqpsol.Phard, res_quadprog.mpqpsol.Phard]);
P1 = Polyhedron('H',double(res_lcp.mpqpsol.Phard));
P2 = Polyhedron('H',double(res_quadprog.mpqpsol.Phard));
Pdiff = P1 \ P2;

if numel(Pdiff)>1 || any(~isEmptySet(Pdiff))
    error('The LCP solver returned wrong partition when comparing to quadprog.');
end

end