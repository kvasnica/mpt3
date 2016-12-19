function test_polyhedron_isfulldim_09_pass
%
% isFullDim test
% 
% 

% random array
Q = Polyhedron('H',randn(2,3));
P = Polyhedron('V',randn(5,2));
R = Polyhedron('V',randn(14,3),'R',randn(4,3));
if ~all(isFullDim([P Q 0.5*R]))
    error('Given polyhedron objects should not full-dimensional.');
end

end
