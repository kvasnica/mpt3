function test_polyhedron_isfulldim_08_pass
%
% isFullDim test
% 
% 

% random rays
Q = Polyhedron('R',randn(2,3));
if isFullDim(Q)
    error('Given polyhedron object should not be full-dimensional.');
end
