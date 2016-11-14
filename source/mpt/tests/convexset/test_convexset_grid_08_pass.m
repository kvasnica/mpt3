function test_convexset_grid_08_pass
%
% unbounded set
% 

x = sdpvar(2,1);
F1 = [ x >=0 ]; 

Y1 = YSet(x,F1);

[worked, msg] = run_in_caller('x = Y1.grid(20); ');
assert(~worked);
asserterrmsg(msg,'Can only grid bounded sets.');

end

