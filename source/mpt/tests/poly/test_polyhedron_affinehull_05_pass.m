function test_polyhedron_affinehull_05_pass
%
% V-polyhedron
%


% comping hull from V polyhedron is very sensitive to decimal number due to
% computation of null space, for instance the following vertices differ in
% digits they are displayed to the user
V1 = [-1.160605008075912   1.258776373971985  -1.274927843366562
  -1.175207854630737   1.322756589700320  -1.280443489366359
   0.084429496605087   0.489439279285236   0.219775949715434
   0.330357486784678  -1.100407505354714   0.200647307060660
   0.019798258786023  -1.999405766977905  -0.410699327754067];
V2 = [-1.1606       1.2588      -1.2749
      -1.1752       1.3228      -1.2804
     0.084429      0.48944      0.21978
      0.33036      -1.1004      0.20065
     0.019798      -1.9994      -0.4107];

P1 = Polyhedron('V',V1);
P2 = Polyhedron('V',V2);

% computing affine hull is different for V1 and V2!
a1 =  P1.affineHull;
a2 =  P2.affineHull;

% correct solution
He = [ 1.3356      0.21864           -1  0];
H = [     -2.7602           -1            0       1.9448
      -4.3814           -1            0       3.8262
       1.2132       1.8339            0            1
       6.4647            1            0       1.0352
       2.8948           -1            0       2.0567];

an = a1/a1(1);
Hen = He/He(1);
   
if norm(an-Hen)>1e-4
    error('These affine hulls must be equal.');
end

end