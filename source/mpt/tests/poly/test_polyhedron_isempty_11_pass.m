function test_polyhedron_isempty_11_pass
%
% isempty test
% 
% 

% positive orthant
P = Polyhedron('H',[-eye(3) zeros(3,1)]);
if isEmptySet(P)
    error('Given polyhedron object should not be empty');
end
