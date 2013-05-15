function test_mpt_mplp_03_pass
% test Opt.solve with the mplp solver

sdpvar x u
C = [-1 <= x+u <= 1; -1<=x<=1; -1<=u<=1];
obj = abs(u)+abs(x);
O = Opt(C, obj, x, u);

w = warning; warning off
S = struct(O);
warning(w);

S.solver = 'MPLP';
O = Opt(S);
assert(isequal(O.solver, 'MPLP'));
assert(isa(O, 'Opt'));

T = evalc('sol = O.solve;');
disp(T);
assert(length(sol.xopt.Set)==2);
% make sure mpt_mplp_26 was really called
assert(~isempty(findstr(T, 'mpt_mplp:')));
assert(~isempty(findstr(T, 'Calling mpt_mplp')));

end
