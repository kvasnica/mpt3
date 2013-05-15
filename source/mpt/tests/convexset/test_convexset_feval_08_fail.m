function test_convexset_feval_08_fail
%
% Yset, general function, string is not in the list
%

x = sdpvar(2,1);

F = set([-1;-2] < x < [1;2]);
Y = YSet(x,F,sdpsettings('verbose',0));

Y.addFunction(QuadFunction(rand(2),[1 -1]),'qf');
Y.addFunction(AffFunction(rand(2),[1;-1]),'af');


y = Y.feval([-1,2],'f');



end