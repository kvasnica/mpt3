function test_polyunion_min_01_pass
% test that PolyUnion/min rejects wrong types of calls

model = LTISystem('A', 1, 'B', 1, 'C', 1);
model.x.min = -1; model.x.max = 1;
model.u.min = -1; model.u.max = 1;
model.x.penalty = QuadFunction(1);
model.u.penalty = QuadFunction(1);
ctrl = MPCController(model, 1).toExplicit;
PUs = [ctrl.optimizer ctrl.optimizer];

% opt_sincos; probStruct.N = 1; probStruct.norm=2;
% sysStruct.xmax = 1.5*[1;1];
% sysStruct.xmin = 1.5*[-1; -1];
% model = mpt_import(sysStruct, probStruct);
% ctrl = MPCController(model, probStruct.N).toExplicit;
% PUs = ctrl.optimizer;

% if there are multiple functions in the polyunion and the user does not
% specify which one to use for comparison, we should give an error
try
	Q = PUs.min;
	failed = false;
	T = '';
catch
	failed = true;
	LE = lasterror;
	T = LE.message;
end
assert(failed);
assert(~isempty(findstr(T, 'Please specify which function to use for comparison.')));

% using a function which does not exist
try
	Q = PUs.min('nonexistingfunction');
	failed = false;
	T = '';
catch
	failed = true;
	LE = lasterror;
	T = LE.message;
end
assert(failed);
assert(~isempty(findstr(T, 'Couldn''t find function "nonexistingfunction".')));

% cannot compare quadratic functions
try
	Q = PUs.min('obj');
	failed = false;
	T = '';
catch
	failed = true;
	LE = lasterror;
	T = LE.message;
end
assert(failed);
assert(~isempty(findstr(T, 'Only PWA functions can be used for comparison.')));

end
