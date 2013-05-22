function test_polyunion_locatePoint_05_fail
%
% problem coming from MPLP solver
% 

n = 6;
d = 3;

P = ExamplePoly.randVrep('d',3)*5;

problem = Opt('f',randn(n,1),'A',randn(18,n),'b',5*rand(18,1),'pB',randn(18,d),'Ath',P.A,'bth',P.b,'solver','mplp');

res = problem.solve;
U = res.xopt;
U.locatePoint(rand(d,1));


end