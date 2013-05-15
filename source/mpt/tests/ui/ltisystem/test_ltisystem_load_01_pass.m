function test_ltisystem_load_01_pass
% tests AbstractSystem/saveobj

% uninstantiated object with default filters
L = LTISystem('A', 1, 'B', 2);
save ltidata L
clear
load ltidata
assert(isequal(L.A, 1));
assert(isequal(L.B, 2));
assert(L.x.hasFilter('min'));
assert(L.x.min==-Inf);
assert(~L.x.hasFilter('terminalPenalty'));
delete('ltidata.mat');
clear

% uninstantiated object with custom filters
L = LTISystem('A', 1, 'B', 2);
L.x.with('terminalPenalty');
save ltidata L
clear
load ltidata
assert(isequal(L.A, 1));
assert(isequal(L.B, 2));
assert(L.x.hasFilter('min'));
assert(L.x.min==-Inf);
assert(L.x.hasFilter('terminalPenalty'));
delete('ltidata.mat');
clear

% instantiated object with custom filters
L = LTISystem('A', 1, 'B', 2);
L.x.with('terminalPenalty');
L.instantiate(3);
assert(isa(L.x.var, 'sdpvar'));
assert(isequal(size(L.x.var), [1 4]));
assign(L.x.var, [1 2 3 4]);
save ltidata L
% %test that saving didn't remove variables
assert(isa(L.x.var, 'sdpvar'));
assert(isequal(size(L.x.var), [1 4]));
clear
load ltidata
assert(isequal(L.A, 1));
assert(isequal(L.B, 2));
assert(L.x.hasFilter('min'));
assert(L.x.min==-Inf);
assert(L.x.hasFilter('terminalPenalty'));
assert(~isempty(L.x.var)); % SystemSignal/saveobj should have saved the value
assert(isequal(L.x.value, [1 2 3 4]));
delete('ltidata.mat');
clear

end
