function test_polyhedron_isempty_16_pass
%
% isempty test on symmetric polyhedron
% 
% 

P = ExamplePoly.randZono;
if isEmptySet(P)
    error('Given polyhedron object is not empty!');
end
