function test_mpccontroller_getMatrices_01_pass
% pQP

model = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
model.x.min = [-5; -5];
model.x.max = [5; 5];
model.u.min = -1;
model.u.max = 1;
model.x.penalty = QuadFunction(eye(2));
model.u.penalty = QuadFunction(1);
N = 5;
ctrl = MPCController(model, N);

M = ctrl.getMatrices(); % must get a pQP with 5 optimization variables
assert(isstruct(M));
assert(isequal(size(M.F), [2 5]));
assert(isequal(size(M.H), [5 5]));
assert(isequal(size(M.Y), [2 2]));
assert(isequal(size(M.G), [34 5]));
assert(isequal(size(M.W), [34 1]));
assert(isequal(size(M.E), [34 2]));
assert(isequal(size(M.Cf), [1 5]));
assert(isequal(size(M.Cx), [1 2]));
assert(isequal(size(M.Cc), [1 1]));
assert(M.qp==1);

Hexp = [4.6875 0.25 2 -0.25 -1.45833333333333;0.25 4 0.5 -2 1.16666666666667;2 0.5 4.75 -0.5 -1.66666666666667;-0.25 -2 -0.5 2 -1.16666666666667;-1.45833333333333 1.16666666666667 -1.66666666666667 -1.16666666666667 6.75];
assert(norm(M.H-Hexp)<1e-6);

end
