function test_polyhedron_isempty_08_pass
%
% isempty test
% 
% 

P = Polyhedron(randn(14,2),ones(14,1));

if isEmptySet(P)
    error('Given polyhedron object should be not empty');
end
