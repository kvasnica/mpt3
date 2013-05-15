function test_convexset_feval_07_fail
%
% Yset, general function, string is greater than the number of functions
%

x = sdpvar(2,1);

F = set([-1;-2] < x < [1;2]);
Y = YSet(x,F,sdpsettings('verbose',0));

Y.addFunction(QuadFunction(rand(2),[1 -1]),'qf');
Y.addFunction(AffFunction(rand(2),[1;-1]),'af');


y = Y.feval([-1,2],3);



end