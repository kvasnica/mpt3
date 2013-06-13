function test_polyunion_locatePoint_07_pass
%
% polyunion with overlaps
% 

for i=1:3
    P(i) = ExamplePoly.randVrep('d',3);
end

U = PolyUnion('Set',P);
U.isOverlapping;

% put adj list to check if the error for the union properties is displayed
U.setInternal('adj_list',{});

[worked, msg] = run_in_caller('U.locatePoint(randn(1,3)); ');
assert(~worked);
asserterrmsg(msg,'This method supports unions of polyhedra that are convex, non-overlapping, bounded, full-dimensional, connected, and come from PLCP solver with an adjacency list.');


end