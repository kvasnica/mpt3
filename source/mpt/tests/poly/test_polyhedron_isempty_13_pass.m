function test_polyhedron_isempty_13_pass
%
% isempty test
% 
% 

V = [0 0 0]; % non-empty vertices = set is NOT empty
P = Polyhedron('V',V);
assert(~P.isEmptySet);

end
