function test_convexset_feval_05_fail
%
% Yset, general function, wrong dimension
%

x = sdpvar(2,1);

F = set([-1;-2] < x < [1;2]);
Y = YSet(x,F,sdpsettings('verbose',0));

Y.addFunction(QuadFunction(rand(2),[1 -1]),'qf');


y = Y.feval(-1);



end