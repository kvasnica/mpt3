function test_polyhedron_contains_14_pass
%
% V-x in 8D
%

P = Polyhedron([
  -10.237       13.837      -9.4232      -9.3024       21.874      -6.7634      -26.975      -10.792
  2.0887      -16.036       52.345      -17.943       29.798       13.156       17.846      -15.183
 -12.175      -11.206      -4.6045      -25.142       4.0689       -55.36      -8.7462       11.854
 -1.6538       15.924      -3.3391      -14.072      -1.3979        6.812       9.8637       21.347
  11.397      -6.2422       2.4949       1.2831      -14.771       6.1222       8.7104      -10.588]);


% check each vertex
x = P.V'; % the points must be column vectors
assert(size(x, 1)==P.Dim);
t = P.contains(x);
% "t" must be a (1 x nv) vector
nv = size(P.V, 1);
assert(isequal(size(t), [1 nv]));
% all points must be contained
assert(all(t));

% check center of vertices
xc=mean(x, 2);
if ~P.contains(xc)
    error('The center must be inside.');
end


end
