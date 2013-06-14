function test_convexset_feval_05_pass
%
% function defined over YSet
%

x = sdpvar(2,1);
F = ([-1;-2] <= x <= [1;2]);
Y = YSet(x,F,sdpsettings('verbose',0));
fun = QuadFunction(rand(2),[1 -1]);
Y.addFunction(fun, 'qf');

% point inside
x = [-1; .1];
[y, feasible] = Y.feval(x);
assert(isequal(y, fun.feval(x)));
assert(feasible);

% point outside
x = [100; .1];
[y, feasible] = Y.feval(x);
assert(~feasible);
assert(isscalar(y));
assert(isnan(y));

end
