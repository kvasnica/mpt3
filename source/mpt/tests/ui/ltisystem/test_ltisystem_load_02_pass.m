function test_ltisystem_load_02_pass
% tests AbstractSystem/saveobj with filters which add new variables

% uninstantiated object with custom filters
L = LTISystem('A', 1, 'B', 2);
L.x.with('softMax');
L.x.with('softMin');
save ltidata L
clear
load ltidata
assert(isequal(L.A, 1));
assert(isequal(L.B, 2));
assert(L.x.hasFilter('min'));
assert(L.x.hasFilter('softMax'));
assert(L.x.hasFilter('softMin'));
assert(~isempty(L.x.min));
assert(isstruct(L.x.softMin));
assert(isstruct(L.x.softMax));
% check that the 'softMax' filter deactivated 'max'
assert(~L.x.isFilterEnabled('max'));
assert(~L.x.isFilterEnabled('min'));
assert(L.x.isFilterEnabled('softMax'));
assert(L.x.isFilterEnabled('softMin'));
delete('ltidata.mat');
clear

% instantiated object with custom filters
L = LTISystem('A', 1, 'B', 2);
L.x.with('softMax');
L.x.with('softMin');
L.instantiate(3);
assert(isa(L.x.var, 'sdpvar'));
assert(isequal(size(L.x.var), [1 4]));
save ltidata L
% %test that saving didn't remove variables
assert(isa(L.x.var, 'sdpvar'));
assert(isequal(size(L.x.var), [1 4]));
clear
load ltidata
assert(isequal(L.A, 1));
assert(isequal(L.B, 2));
assert(L.x.hasFilter('min'));
assert(L.x.hasFilter('softMax'));
assert(L.x.hasFilter('softMin'));
% check that the 'softMax' filter deactivated 'max'
assert(~L.x.isFilterEnabled('max'));
assert(~L.x.isFilterEnabled('min'));
assert(L.x.isFilterEnabled('softMax'));
assert(L.x.isFilterEnabled('softMin'));
assert(~isempty(L.x.min));
assert(isstruct(L.x.softMin));
assert(isstruct(L.x.softMax));
assert(~isempty(L.x.var)); % SystemSignal/saveobj should have saved the value
assert(all(isnan(L.x.value))); % unoptimize sdpvars are set to NaN
assert(isequal(size(L.x.value), [1 4]));
delete('ltidata.mat');
clear

end
