function test_polyhedron_isempty_12_pass
%
% isempty test
% 
% 

% empty polyhedron obtained from parametric programming example
A = [ 0.055625    -0.030184;
      0.21887      0.06688;
    -0.046337    -0.013508];
b = [0;0;0];

% positive orthant
P = Polyhedron(A,b);
if isFullDim(P)
    error('Given polyhedron object should not be full-dimensional because it contains only a point.');
end
