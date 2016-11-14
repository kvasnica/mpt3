function test_yset_11_pass
%
% circle
%

A = randn(10,2);
b = 3*rand(10,1);
xc = sdpvar(2,1);
r = sdpvar(1);
solvesdp(A*xc+r*sqrt(sum(A.^2,2)) <= b,-r,sdpsettings('verbose',0));

x = sdpvar(2,1);
F1 = (A*x <= b);
F2 = (norm(x-double(xc),2)<=double(r));


S1 = YSet(x,F1);
S2 = YSet(x,F2);

S = [S1;S2];
end
