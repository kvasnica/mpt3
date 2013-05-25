function test_function_08_pass
%
% parameters in the handle
%

F = Function([], struct('a',1.5));
F.setHandle(@(x) F.Data.a*x^3-1);

assert(F.feval(1)==0.5);

% now change the data
F.Data.a=2;
assert(F.feval(1)==1);

end
