function test_polyhedron_isfulldim_10_pass
%
% isFullDim test
% 
% 

% fulldim
Q = Polyhedron('H',randn(2,3));
% lowdim
R = Polyhedron('H',randn(2,3),'He',randn(1,3));

% intersection of fulldim and lowdim should be lowdim
if isFullDim(intersect(Q,R))
    error('Given polyhedron objects should not be full-dimensional.');
end
