function test_polyunion_locatePoint_05_pass
%
% random MPLP problem - solve by DFS instead of BFS
% 

n = 6;
d = 2;

P = ExamplePoly.randVrep('d',d)*5;

% turn on DFS
a = mptopt;
bfs = a.modules.solvers.plcp.bfs;
dfs = a.modules.solvers.plcp.dfs;
a.modules.solvers.plcp.bfs = 0;
a.modules.solvers.plcp.dfs = 1;

% solve using DFS
problem = Opt('f',randn(n,1),'A',randn(18,n),'b',5*rand(18,1),'pB',randn(18,d),'Ath',P.A,'bth',P.b);
res = problem.solve;
U = res.xopt;

% turn on old settings
a = mptopt;
a.modules.solvers.plcp.bfs = bfs;
a.modules.solvers.plcp.dfs = dfs;

% check solution

for i=1:U.Num;
    x = U.Set(i).grid(10);
    for j=1:size(x,1)
        index = U.locatePoint(x(j,:));
        if ~U.Set(index).contains(x(j,:))
            error('Wrong region detected.');
        end
    end
end



end