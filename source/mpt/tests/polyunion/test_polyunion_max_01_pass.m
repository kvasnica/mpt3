function test_polyunion_max_01_pass
% test that PolyUnion/min rejects wrong types of calls

model = LTISystem('A', 1, 'B', 1, 'C', 1);
model.x.min = -1; model.x.max = 1;
model.u.min = -1; model.u.max = 1;
model.x.penalty = QuadFunction(1);
model.u.penalty = QuadFunction(1);
ctrl = MPCController(model, 1).toExplicit;
PUs = [ctrl.optimizer ctrl.optimizer];

% if there are multiple functions in the polyunion and the user does not
% specify which one to use for comparison, we should give an error
try
	Q = PUs.max;
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
	Q = PUs.max('nonexistingfunction');
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
	Q = PUs.max('obj');
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
