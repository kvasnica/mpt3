function test_filter_reference_03_pass
% reference with trajectory preview

nx = 2;
x = SystemSignal(nx);
x.name = 'x';
x.with('reference');

x.reference = 'preview';
assert(isequal(x.reference, 'preview'));

% instantiate() must create a nx-by-N sdpvar
N = 4;
x.instantiate(N);
assert(isa(x.Internal.reference.var, 'sdpvar'));
assert(isa(x.var, 'sdpvar'));
assert(isequal(size(x.var), [2 4]));

% getVariables() must return the vectorized variable
out = x.applyFilters('getVariables');
assert(isa(out.var, 'sdpvar'));
assert(isequal(size(out.var), [8 1]));
assert(out.parametric); % must be included in the vector of parameters

% variable must be properly destroyed
x.applyFilters('uninstantiate');
assert(isempty(x.Internal.reference.var));

end
