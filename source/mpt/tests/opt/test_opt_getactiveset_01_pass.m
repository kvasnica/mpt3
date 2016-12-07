function test_opt_getactiveset_01_pass

Double_Integrator
M = mpt_constructMatrices(sysStruct, probStruct);
pqp = Opt(M);
[A, sol] = pqp.getActiveSetForPoint([0; 0]);
xexp = zeros(5, 1);
assert(isempty(A)); assert(norm(sol.xopt-xexp)<1e-5);

[A, sol] = pqp.getActiveSetForPoint([3; 0]);
Aexp = 4; xexp = [-1;-0.56953;0.25403;0.41049;0.34608];
assert(isequal(A, Aexp)); assert(norm(sol.xopt-xexp)<1e-5);

[A, sol] = pqp.getActiveSetForPoint([3; 1]);
Aexp = [4; 8; 12]; xexp = [-1;-1;-1;-0.30965;0.2567];
assert(isequal(A, Aexp)); assert(norm(sol.xopt-xexp)<1e-5);

[A, sol] = pqp.getActiveSetForPoint([30; 1]); % infeasible
assert(isnan(A)); assert(isequal(sol.how, 'infeasible'));


end
