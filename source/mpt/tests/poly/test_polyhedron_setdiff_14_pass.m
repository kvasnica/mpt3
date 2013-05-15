function test_polyhedron_setdiff_14_pass
%
% P=full-dim, unbounded,
% Q=full dim which is contained inside P
%
H = [ -1           -3         14.5
      -1     3.35e-14           10
      -1           -1           11
      -1           -2         12.5
     1       5.9998         23.5];
 
P = Polyhedron('H',H);
Q = Polyhedron('H',...
 [0.45747      0.88922     -0.79166;
  -0.36383      0.93147       3.4506;
  -0.010158     -0.99995      -1.3703]);

T = P\Q;

if numel(T)~=3
    error('Here should be 3 polyhedra.');
end
    

end