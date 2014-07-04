function test_mpt_mpqp_03_pass

sdpvar x u

% as of June 4, 2012 construction of Opt fails due to a bug, probably due
% to not having constraints on all variables
%O = Opt([-1 <= x+u <= 1], u'*u+x'*x, x, u);
O = Opt([-1 <= x+u <= 1; -5<=x<=5; -5<=u<=5], u'*u+x'*x, x, u);
% force the MPQP solver
O.solver = 'MPQP';

T = evalc('sol = O.solve;');
disp(T);
% make sure mpt_mpqp_26 was really called
assert(~isempty(findstr(T, 'mpt_mpqp:')));

assert(length(sol.xopt.Set)==3);
assert(isa(sol.xopt.Set, 'Polyhedron'));

end
