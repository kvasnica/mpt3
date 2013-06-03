function test_empccontroller_deltabound_01_pass
% deltamin/deltamax bounds on inputs (requires extra variables)
%
% same as test_mpccontroller_deltabound_01_pass, just with N=3

N = 2;
x0 = [10; 1];
uprev = 0;
L = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
L.x.penalty = QuadFunction(eye(2));
L.u.penalty = QuadFunction(1);
L.u.min = -5;
L.u.max = 5;

%% only deltaMax
L.u.with('deltaMax');
L.u.deltaMax = 0.5;
ctrl = EMPCController(L, N);
[~, feasible, openloop] = ctrl.evaluate(x0, 'u.previous', uprev);
assert(feasible);
du = diff([uprev, openloop.U]);
assert(max(du) <= ctrl.model.u.deltaMax+1e-6);
if N==3
	Jgood = 202.040760869773;
else
	Jgood = 178.942307695058;
end
assert(abs(openloop.cost-Jgood)<=1e-8);

%% only deltaMin
L.u.without('deltaMax');
L.u.with('deltaMin');
L.u.deltaMin = -0.5;
[~, feasible, openloop] = ctrl.evaluate(x0, 'u.previous', uprev);
assert(feasible);
du = diff([uprev, openloop.U]);
assert(min(du) >= ctrl.model.u.deltaMin-1e-6);
if N==3
	Jgood = 483.549843793654;
else
	Jgood = 212.06250000004;
end
assert(abs(openloop.cost-Jgood)<=1e-8);

%% deltaMax and deltaMin
L.u.with('deltaMax');
L.u.deltaMin = -2;
L.u.deltaMax = 1.3;
[~, feasible, openloop] = ctrl.evaluate(x0, 'u.previous', uprev);
assert(feasible);
du = diff([uprev, openloop.U]);
assert(min(du) >= ctrl.model.u.deltaMin-1e-6);
assert(max(du) <= ctrl.model.u.deltaMax+1e-6);
if N==3
	Jgood = 236.046923148207
else
	Jgood = 186.490000013152;
end
assert(abs(openloop.cost-Jgood)<=1e-8);

%% previous value out of bounds
[~, feasible, openloop] = ctrl.evaluate(x0, 'u.previous', L.u.max*2);
assert(~feasible);

%% wrong options
[~, msg] = run_in_caller('ctrl.evaluate(x0)');
asserterrmsg(msg, 'Please provide initial value of "u.previous".');
[~, msg] = run_in_caller('ctrl.evaluate(x0, ''u.previous'', [1; 2])');
asserterrmsg(msg, '"u.previous" must be a 1x1 vector.');

end
