function test_polyhedron_isadjacent_19_pass
% test for issue #77

% these two polytopes are NOT adjacent since their intersection is NOT a
% facet of both
R1 = Polyhedron([0 0; 2 0; 0 1; 2 1]); 
R2 = Polyhedron([1 0; 2 0; 1 -1; 2 -1]); 
assert(~R1.isAdjacent(R2));

end
