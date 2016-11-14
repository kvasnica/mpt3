function test_mpccontroller_getMatrices_04_pass
% formulations with binary/integer variables must be rejected

% binary inputs
model = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
model.x.min = [-5; -5];
model.x.max = [5; 5];
model.u.min = -1;
model.u.max = 1;
model.x.penalty = OneNormFunction(eye(2));
model.u.penalty = OneNormFunction(1);
model.u.with('binary');
N = 5;
ctrl = MPCController(model, N);
[~, msg] = run_in_caller('M = ctrl.getMatrices();');
asserterrmsg(msg, 'Formulations with binary/integer variables not supported.');

% PWA model
model = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
model.x.min = [-5; -5];
model.x.max = [5; 5];
model.u.min = -1;
model.u.max = 1;
model.x.penalty = OneNormFunction(eye(2));
model.u.penalty = OneNormFunction(1);
pwamodel = PWASystem([model model]);
ctrl = MPCController(pwamodel, 3);
[~, msg] = run_in_caller('M = ctrl.getMatrices();');
asserterrmsg(msg, 'Formulations with binary/integer variables not supported.');

end
