function test_polyhedron_setdiff_19_pass
% I have investigated a bit. The while loop beginning on line 267 of
% regiondiff (while level~=0) never terminates. level is decremented on
% line 291 after the code apparently determines that 'no Ri intersects
% the node', and then incremented again on line 369. The while loop
% therefore never terminates. If I can hazard a simple guess, should it
% not be options.intersect_tol instead of abs_tol in the if clause on
% line 277? The code seems to be checking if the intersection is empty
% or not.
%
% Good luck and thanks for the great toolbox,
%
% Joseph K. Scott
% Postdoctoral Research Assistant
% Process Systems Engineering Laboratory
% Dept. Chemical Engineering
% MIT

H1 = [1.336e-07  7.8473e-08  -0.0038343     0.99999           0 -5.2478e-06      -6.07009e-05
 1.2821e-09  7.5307e-10 -3.7604e-05    0.019502           0 -0.99981         0.0010962
 1.2821e-09  7.5308e-10 -3.7605e-05    0.019502     0.99981 -8.4986e-06           15.9981
 3.5624e-05  2.0924e-05          -1  1.6956e-10           0 -5.6107e-11         -0.064734
          1  2.0926e-05 -7.1271e-06 -6.4727e-07           0 -3.15e-06           19.9339
-3.5761e-05    -0.99999   0.0038785 -1.7021e-10           0 5.6323e-11          -33.9251
-1.2821e-09 -7.5308e-10  3.7605e-05   -0.019502    -0.99981 8.4986e-06     -15.9959
-3.5624e-05 -2.0924e-05           1 -1.6956e-10           0 5.6107e-11         0.0699907
         -1 -2.0926e-05  7.1271e-06  6.4727e-07           0 3.15e-06          -19.9251
 3.5761e-05     0.99999  -0.0038785  1.7021e-10           0 -5.6323e-11           33.9341
          0           0   0.0036688    -0.99999           0 0       6.43101e-05
          0           0  3.4395e-05   -0.018647           0 0.99983       -0.00108091];

H2= [0           0  -0.0036688     0.99999           0           0 0.000449709
 0           0 -3.4395e-05    0.018647           0    -0.99983  0.00108094
 0           0 -3.4395e-05    0.018647     0.99983           0     15.9983
 0           0          -1  1.6943e-10           0           0  -0.0691297
 1           0  -6.778e-06 -6.4807e-07           0           0     19.9339
 0    -0.99999   0.0037096 -1.7006e-10           0           0    -33.9251
 0           0   0.0036688    -0.99999           0           0 0.000233008
 0           0  3.4395e-05   -0.018647           0     0.99983    0.001048
 0           0  3.4395e-05   -0.018647    -0.99983           0    -15.9962
 0           0           1 -1.6943e-10           0           0   0.0743183
-1           0   6.778e-06  6.4807e-07           0           0    -19.9251
 0     0.99999  -0.0037096  1.7006e-10           0           0     33.9341];


P1 = Polyhedron('H',H1);
P2 = Polyhedron('H',H2);

R = P1\P2;

if isEmptySet(R)
    error('R is not empty.');
end

end