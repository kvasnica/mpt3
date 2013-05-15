function test_mpt_mpqp_01_pass

sdpvar x u

% we have problems with not all variables being constrained. even MPT2
% fails here
%sol = solvemp([-1 <= x+u <= 1], u'*u+x'*x, sdpsettings('debug', 1), x, u);

sol = solvemp([-1 <= x+u <= 1; -5 <= x <= 5; -5 <= u <= 5], u'*u+x'*x, sdpsettings('debug', 1), x, u);
assert(~isempty(sol));
assert(isa(sol{1}.Pn, 'polytope'));
assert(isa(sol{1}.Pfinal, 'polytope'));
assert(length(sol{1}.Fi)==3);
assert(length(sol{1}.Pn)==3);
assert(length(sol{1}.Pfinal)==1);
assert(ismethod(sol{1}.Pn(1), 'toPolyhedron'));

end
