function test_filter_reference_02_pass
% free reference

x = SystemSignal(2);
x.name = 'x';
x.with('reference');

% bogus settings
[~, msg] = run_in_caller('x.reference = ''bogus''');
asserterrmsg(msg, 'The value of reference must be ''free''.');

% correct settings
x.reference = 'free';
assert(isequal(x.reference, 'free'));

% must respond to callbacks
x.applyFilters('instantiate');

out = x.applyFilters('getInitVariables');
assert(isequal(out.name, x.name));
assert(isequal(out.filter, 'reference'));
assert(isa(out.var, 'sdpvar'));

out = x.applyFilters('getVariables');
assert(isa(out, 'sdpvar'));

x.applyFilters('uninstantiate');


end
