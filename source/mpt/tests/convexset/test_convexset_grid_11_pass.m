function test_convexset_grid_11_pass
%
% empty (infeasible) polyhedron
% 

P = Polyhedron('lb',[0;-1;-2], 'ub', [3, 4,5], 'A',randn(1234,3),'b',randn(1234,1));

[worked, msg] = run_in_caller('x = P.grid(10); ');
assert(~worked);
asserterrmsg(msg,'Empty set, there is nothing to be gridded here.');

end

