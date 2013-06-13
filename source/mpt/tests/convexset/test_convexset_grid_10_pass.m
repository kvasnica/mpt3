function test_convexset_grid_10_pass
%
% unbounded polyhedron
% 

P = Polyhedron('lb',[0;-1;-2]);

[worked, msg] = run_in_caller('x = P.grid(10); ');
assert(~worked);
asserterrmsg(msg,'Can only grid bounded sets.');

end

