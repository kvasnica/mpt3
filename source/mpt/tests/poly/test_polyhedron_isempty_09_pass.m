function test_polyhedron_isempty_09_pass
%
% isempty test
% 
% 

P = Polyhedron(randn(46,25));

if isEmptySet(P)
    error('Given polyhedron object should be not empty');
end
