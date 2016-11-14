function test_polyhedron_isfulldim_07_pass
%
% isFullDim test
% 
% 

% only equalities
Q = Polyhedron('he',randn(2,6));
if isFullDim(Q)
    error('Given polyhedron object should not be full-dimensional.');
end
