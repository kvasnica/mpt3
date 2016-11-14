function test_mpt_mplp_03_pass
% test Opt.solve with the mplp solver

sdpvar x u
C = [-1 <= x+u <= 1; -1<=x<=1; -1<=u<=1];
obj = abs(u)+abs(x);
O = Opt(C, obj, x, u);
O.solver = 'mplp';

T = evalc('sol = O.solve;');
disp(T);
assert(length(sol.xopt.Set)==2);
% make sure mpt_mplp_26 was really called
assert(~isempty(findstr(T, 'mpt_mplp:')));

end
