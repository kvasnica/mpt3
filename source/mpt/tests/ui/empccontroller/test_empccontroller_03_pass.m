function test_empccontroller_03_pass
% import from model

% LTI
model = LTISystem('A', 1, 'B', 1, 'C', 1, 'D', 0);
model.x.max = 5; model.x.min = -5;
model.u.max = 1; model.u.min = -1;

% mpqp
model.x.penalty = Penalty(1, 2);
model.u.penalty = Penalty(1, 2);
E = EMPCController(model, 2);
E.display();
assert(E.isExplicit);
assert(E.nr==3);
assert(numel(E.optimizer)==1);

% mplp
model.x.penalty = Penalty(1, 1);
model.u.penalty = Penalty(1, 1);
E = EMPCController(model, 2);
E.display();
assertwarning(E.nr==4 || E.nr==3); % 4 with mplp, 3 with plcp, check cost
[~, ~, openloop] = E.evaluate(-1);
assert(isequal(openloop.cost, 2));
assert(numel(E.optimizer)==1);

% MLD/mpMILP
c = pwd;
cd(fileparts(which('test_empccontroller_03_pass')));
model = MLDSystem('pwa_car');
cd(c);
model.x.penalty = Penalty(eye(2), 1);
model.u.penalty = Penalty(1, 1);
E = EMPCController(model, 2);
assertwarning(E.nr==101 || E.nr==103); % 101 with mplp, 103 with plcp, check cost
assertwarning(numel(E.optimizer)==13);
x = [0.7; -2];
[~, ~, openloop] = E.evaluate(x);
Jgood = 5.2;
assert(norm(openloop.cost-Jgood)<1e-10);

% MLD/mpMIQP
% we used to have a missing region around [-0.7; 2] (probably a problem
% with plotting)
model.x.penalty = Penalty(eye(2), 2);
model.u.penalty = Penalty(1, 2);
E = EMPCController(model, 2);
assert(E.nr==65 || E.nr==66); % 65 with mplp, 66 with plcp, check cost
x = [0.7; -2];
[u, ~, openloop] = E.evaluate(x);
ugood = 0.19553971445;
Jgood = 8.70138090641321;
assert(norm(u-ugood)<1e-10);
assert(norm(openloop.cost-Jgood)<1e-10);
assert(numel(E.optimizer)==13);

end
