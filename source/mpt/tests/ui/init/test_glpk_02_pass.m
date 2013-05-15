function test_glpk_02_pass
% make sure GLPK was detected

m = mptopt;
assert(~isempty(strmatch('GLPK', m.solvers_list.MILP)));
assert(~isempty(strmatch('GLPK', m.solvers_list.LP)));

end
