function test_convexset_feval_03_fail
%
% point outside of the set and in the wrong dim
%

x = sdpvar(2,1);
F = set([-4;-4]<x<[3;3]);
S = YSet(x,F,sdpsettings('verbose',0));
S.addFunction(QuadFunction(rand(2),rand(1,2)));

y = S.feval([5,0,1]);


end