function test_polyhedron_contains_03_pass
%
% H-V in 3D 
%

P = Polyhedron('H',[
   0.26615       1.4882     -0.12415       2.3334
  -0.91029      0.97411       1.1161      0.82428
   0.65514      0.65219        1.372        2.822
   -1.0098      -1.9083     -0.80278       3.9898
  -0.60607       1.1112      -2.1944       3.2953
   0.64102     -0.82137      0.27259       3.0735
  -0.80535     -0.79705     -0.57369       1.5575
    1.5314     -0.78663      0.37296     0.016899]);

S = Polyhedron([
       2.5283       1.0007       1.1565
      0.48892      0.32687       1.3883
     -0.30348      0.65841       1.4099
      0.80255      -2.1972     -0.17597
      0.54639      0.71233       1.0107]);

  
if P.contains(S) || S.contains(P)
    error('Polyhedra are not contained inside one another.');
end

% center of P
xc = chebyCenter(P);

% move S to P
R = S*0.2+xc.x;

% P must contain R
if ~P.contains(R)
    error('R is contained in S.');
end
    


end