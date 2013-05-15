function test_systemsignal_foreach_01_pass

% no outputs
s1 = SystemSignal(3);
s2 = SystemSignal(5);
% variables are not instantiated by default
assert(isempty(s1.var));
assert(isempty(s2.var));
Z = [s1 s2];
Z.forEach(@(x) x.instantiate(2));
% check that variables have been instantiated
assert(isa(s1.var, 'sdpvar'));
assert(isa(s2.var, 'sdpvar'));
assert(isequal(size(s1.var), [3 2]));
assert(isequal(size(s2.var), [5 2]));

% uniform outputs
s1 = SystemSignal(3);
s2 = SystemSignal(5);
Z = [s1 s2];
out = Z.forEach(@(x) x.n);
assert(isequal(out, [3 5]));

end
