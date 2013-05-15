function test_polyhedron_chebyCenter_01_pass
%
% this polyhedron is not empty and thus must have center
%
H=[  -0.053731    -0.010858  -8.2087e-08;
      0.25807     0.078687   2.4926e-07;
     -0.21887     -0.06688  -1.1523e-07];
 
 
 P = Polyhedron('H',H);

 res = P.chebyCenter;
 
 if res.r<0
     error('This polyhedron must have a center.');
 end
 
 

end