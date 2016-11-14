function test_convexset_grid_09_pass
%
% not feasible
% 

x = sdpvar(2,1);
F1 = [ x >=0 ; x <= -1];

Y1 = YSet(x,F1);

[worked, msg] = run_in_caller('x = Y1.grid(20); ');
assert(~worked);
asserterrmsg(msg,'Empty set, there is nothing to be gridded here.');

end

