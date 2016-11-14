function test_opt_38_pass
% tests setting of parameterized cost (issue #117)

% the pF term must be set correctly
sdpvar x t
prob = Opt([0<=t<=1,1<=x<=2],t*x,t,x); 
assert(prob.pF==1);

prob = Opt([0<=t<=1,1<=x<=2],2*t*x,t,x); 
assert(prob.pF==2);

prob = Opt([0<=t<=1,1<=x<=2],2*t*x+x'*x,t,x); 
assert(prob.pF==2);

t = sdpvar(2, 1);
prob = Opt([0<=t<=1,1<=x<=2],t'*[1;2]*x+x'*x,t,x);
assert(isequal(prob.pF, [1, 2]));

end
