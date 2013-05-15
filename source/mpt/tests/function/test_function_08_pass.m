function test_function_08_pass
%
% parameters in the handle
%

F = Function([], struct('a',1.5));
F.setHandle(@(x) F.Data.a*x^3-1);

if feval(F.Handle,1)~=0.5
    error('Wrong result.')
end
F.Data.a=2;
if feval(F.Handle,1)~=1
    error('Wrong result.');
end
end
