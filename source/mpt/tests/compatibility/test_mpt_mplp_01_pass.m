function test_mpt_mplp_01_pass

sdpvar x u
sol = solvemp([-1 <= x+u <= 1; -1<=x<=1; -1<=u<=1], ...
	abs(u)+abs(x), sdpsettings('debug', 1), x, u);
assert(~isempty(sol));
assert(isa(sol{1}.Pn, 'polytope'));
assert(isa(sol{1}.Pfinal, 'polytope'));
assert(length(sol{1}.Fi)==2);
assert(length(sol{1}.Pn)==2);
assert(length(sol{1}.Pfinal)==1);
assert(ismethod(sol{1}.Pn(1), 'toPolyhedron'));

end
