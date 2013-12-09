function test_opt_feasibleset_05_pass
% feasible set must accept the bounds on the parameters

f = [1; -1; 0.5]; pF = [1 -1.2; -0.8 -2.1; 3.1 0]; 
A = [-11.15 -16.28 -8.09; 6.85 16.17 11.61; 10.37 2.64  5.92; 18.22 -11.28 2.42; -5.29 -5.6 2.4];
b = [ 1.43; 3.49; 3.98; 2.2; 2.23];
B = [ -0.11 0.5; -0.89 -0.83; 0.74 0.2; 1.39 -1.01; 2.47 -0.62];
Ath = [eye(2); -eye(2)]; bth = [2;2;5;5];

% MPLP with parametrized cost
problem = Opt('f',f,'A',A,'b',b,'pB',B,'pF',pF,'Ath',Ath,'bth',bth);

% solution
res = problem.solve;

% feasible set
F = problem.feasibleSet;

% the result must be the same
assert(res.xopt.convexHull==F);


end
