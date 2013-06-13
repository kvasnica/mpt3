function test_polyunion_locatePoint_10_pass
%
% problem coming from MPLP solver
% 

n = 6;
d = 3;

P = ExamplePoly.randVrep('d',3)*5;

problem = Opt('f',randn(n,1),'A',randn(18,n),'b',5*rand(18,1),'pB',randn(18,d),'Ath',P.A,'bth',P.b,'solver','mplp');

res = problem.solve;
U = res.xopt;
[worked, msg] = run_in_caller('U.locatePoint(rand(d,1)); ');
assert(~worked);
asserterrmsg(msg,'The union does not have an adjacency list. Please, use the polyunion output from PLCP solver that contains the adjacency list.');


end