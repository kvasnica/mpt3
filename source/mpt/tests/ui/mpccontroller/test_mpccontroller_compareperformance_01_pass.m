function test_mpccontroller_compareperformance_01_pass
% tests AbstractController/comparePerformance

Double_Integrator
probStruct.Tconstraint = 0;
model = mpt_import(sysStruct, probStruct);

% two on-line controllers, default penalties
c1 = MPCController(model, 1);
c2 = MPCController(model, 2);
[a, m, p1, p2, x0] = c1.comparePerformance(c2, 'grid', 3, 'domain', Polyhedron.unitBox(2)*0.5);
a_e = 86.3408585588748;
m_e = 99.3878700332046;
x0_e = [-0.5 -0.5;-0.5 0;-0.5 0.5;0 -0.5;0 0;0 0.5;0.5 -0.5;0.5 0;0.5 0.5];
assert(norm(a-a_e, Inf) < 1e-6);
assert(norm(m-m_e, Inf) < 1e-6);
assert(norm(x0-x0_e, Inf) < 1e-6);

% two on-line controllers, custom penalties
c1 = MPCController(model, 1);
c2 = MPCController(model, 2);
x0 = [-0.5 -0.5;-0.5 0;-0.5 0.5;0 -0.5;0 0;0 0.5;0.5 -0.5;0.5 0;0.5 0.5];
[a, m, p1, p2, x0] = c1.comparePerformance(c2, 'X0', x0, 'Qx', 0.1*eye(2));
a_e = 82.3595294554644;
m_e = 97.7403849592308;
assert(norm(a-a_e, Inf) < 1e-6);
assert(norm(m-m_e, Inf) < 1e-6);

% one explicit and one on-line controller
e2 = EMPCController(model, 2);
[a, m, p1, p2, x0] = e2.comparePerformance(c1, 'X0', x0, 'Qx', 0.1*eye(2));
a_e = 2419.61845076356;
m_e = 4325.53258531472;
assert(norm(a-a_e, Inf) < 1e-6);
assert(norm(m-m_e, Inf) < 1e-6);

% initial conditions obtained by gridding the domain
[a, m, p1, p2, x0] = e2.comparePerformance(c1, 'grid', 3);
assert(size(x0, 1)==7);

% two explicit controllers
[a, m, p1, p2, x0] = e2.comparePerformance(e2, 'grid', 3);
assert(a==0);
assert(m==0);

end
