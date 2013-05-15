function test_polyunion_min_07_pass
% test for PolyUnion/min with piecewise constant functions


% remove overlaps using the minimum-time piecewise constant cost (=step
% distance) 

Double_Integrator
sysStruct.xmax = 1.5*[1;1];
sysStruct.xmin = 1.5*[-1; -1];
model = mpt_import(sysStruct, probStruct);
ctrl = EMinTimeController(model);

PUs = ctrl.optimizer;
%PUs = ctrl.cost;
out = PUs.min('obj');
assert(out.Num==11);

newctrl = EMPCController(out);
newctrl.nu = 1;
newctrl.N = 1;
F = newctrl.feedback;
C = newctrl.cost;

% test that we are really returning just one function
assert(iscell(F.listFunctions));
assert(length(F.listFunctions)==1);
f = F.listFunctions;
assert(isequal(f{1}, 'primal'));


end
