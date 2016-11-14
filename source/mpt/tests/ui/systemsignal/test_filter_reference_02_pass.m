function test_filter_reference_02_pass
% free reference

x = SystemSignal(2);
x.name = 'x';
x.with('reference');

% bogus settings
[~, msg] = run_in_caller('x.reference = ''bogus''');
asserterrmsg(msg, 'Unrecognized settings. Can only use "free" or "symbolic".');

% correct settings
x.reference = 'free';
assert(isequal(x.reference, 'free'));

% must respond to callbacks
x.applyFilters('instantiate');

out = x.applyFilters('getVariables');
assert(isa(out.var, 'sdpvar'));
assert(out.parametric); % the free reference is a symbolic parameter

x.applyFilters('uninstantiate');


end
