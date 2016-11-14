function test_mpccontroller_getMatrices_02_pass
% pLP

model = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
model.x.min = [-5; -5];
model.x.max = [5; 5];
model.u.min = -1;
model.u.max = 1;
model.x.penalty = OneNormFunction(eye(2));
model.u.penalty = OneNormFunction(1);
N = 5;
ctrl = MPCController(model, N);

M = ctrl.getMatrices(); % must get a pLP with 30 optimization variables
assert(isstruct(M));
assert(M.qp==0);
assert(isequal(size(M.F), [1 2]));
assert(isequal(size(M.H), [1 30]));
assert(isequal(size(M.Y), [2 2]));
assert(isequal(size(M.G), [74 30]));
assert(isequal(size(M.W), [74 1]));
assert(isequal(size(M.E), [74 2]));
assert(isequal(size(M.Cx), [1 2]));
assert(isequal(size(M.Cc), [1 1]));


Hexp = [0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
assert(norm(M.H-Hexp)<1e-6);

end
