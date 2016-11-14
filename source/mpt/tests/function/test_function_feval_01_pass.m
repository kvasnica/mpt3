function test_function_feval_01_pass
%
% evaluation of Function objects

f = @(x) sin(x);
g = Function(f);
x = randn(1);
g_val = g.feval(x);
assert(f(x)==g_val);

% TODO: remove the following test once we rename the Function.Handle
% property to Function.feval
p = g.findprop('Handle');
assert(~isempty(p));
assert(g.Handle(x)==g_val);

end
