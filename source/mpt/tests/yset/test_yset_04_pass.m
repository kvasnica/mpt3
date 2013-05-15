function test_yset_04_pass
%
% array of two YSets
%

x = sdpvar(2,1);
F1 = set(-2 <= x <= 2);
F2 = set(5 <= x <= -1); %infeasible

Y = [YSet(x,F1); YSet(x,F2)];


end
