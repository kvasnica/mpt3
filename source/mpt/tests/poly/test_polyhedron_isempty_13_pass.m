function test_polyhedron_isempty_13_pass
%
% isempty test
% 
% 

V = [0 0 0]; % empty
P = Polyhedron('V',V);
if ~isEmptySet(P)
    error('Given polyhedron object should be empty');
end
