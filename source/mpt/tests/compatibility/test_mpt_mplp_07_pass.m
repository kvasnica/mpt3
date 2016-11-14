function test_mpt_mplp_07_pass
% allow mpt_mplp to solve problems with th'*pF*z in the cost (issue #122)

% the solution has cost equal to "t"
sdpvar x t
prob = Opt([0<=t<=1,1<=x<=2], t*x, t, x);
sol = mpt_call_mplp(prob);
assert(sol.xopt.Num==1);
assert(sol.xopt.Set(1).Functions('obj').F==1);
assert(sol.xopt.Set(1).Functions('obj').g==0);

% two parameters, 3 optimization variables
A = [eye(3); -eye(3)];
b = [1; 1; 1; -0.5; -0.5; -0.5];
u = [2; 2];
c = [1; 1; 1];
D = ones(3, 2);
nx = size(A, 2);
x = sdpvar(nx, 1);
theta = sdpvar(2, 1);
J = (c + D*theta)'*x;
C = [ A*x <= b, x >= 0, 0 <= theta <= u ];
plp = Opt(C, J, theta, x);
sol = mpt_call_mplp(plp);
assert(sol.xopt.Num==1);
Fexp = [1.5 1.5];
gexp = 1.5;
assert(norm(sol.xopt.Set(1).Functions('obj').F - Fexp, Inf)<1e-6);
assert(norm(sol.xopt.Set(1).Functions('obj').g - gexp, Inf)<1e-6);

end
