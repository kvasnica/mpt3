function test_convexset_grid_04_fail
%
% empty (infeasible) polyhedron
% 

P = Polyhedron('lb',[0;-1;-2], 'ub', [3, 4,5], 'A',randn(1234,3),'b',randn(1234,1));

x = P.grid(10);

end

