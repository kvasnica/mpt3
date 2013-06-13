function test_opt_34_pass
%
% opt constructor test
% wrong solver

% include polyhedron to LCP
P = Polyhedron('lb',[-1 -1],'ub',[10;20]);
[worked, msg] = run_in_caller('Opt(''P'',P,''M'',randn(4),''q'',rand(4,1),''Q'',randn(4,2),''solver'',''mplp'');');
assert(~worked);
asserterrmsg(msg,'Given solver is not in the list of parametric LCP solvers.');
