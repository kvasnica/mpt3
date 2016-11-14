function test_solvemp_01_pass
% pLP with parameterized cost (issue #117)

sdpvar x t
SOL = solvemp([0<=t<=1,1<=x<=2],t*x,[],t);
assert(SOL{1}.Bi{1}==1);
assert(SOL{1}.Ci{1}==0);

% the same problem via Opt
prob = Opt([0<=t<=1,1<=x<=2],t*x,t,x); 

% the pF term must be set correctly
assert(prob.pF==1);
sol = prob.solve();
assert(sol.xopt.Set(1).Functions('obj').F==1);
assert(sol.xopt.Set(1).Functions('obj').g==0);


end
