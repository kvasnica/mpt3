function test_polyhedron_isempty_27_pass
% set with a ray is not empty

P = Polyhedron('R',[0,0,1]);
assert(~P.isEmptySet);

end
