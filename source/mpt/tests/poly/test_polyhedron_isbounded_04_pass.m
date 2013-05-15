function test_polyhedron_isbounded_04_pass
%
% isbounded test
% 
% 

% random 5d polytope
P = Polyhedron(randn(41,5),ones(41,1));

if ~isBounded(P)
    error('Given polyhedron object should be bounded.');
end
