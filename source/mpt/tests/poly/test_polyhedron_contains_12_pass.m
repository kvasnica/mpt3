function test_polyhedron_contains_12_pass
%
% [H-V]-V in 3D
%

P(1) = Polyhedron('H',[
      -2.6879      -5.9465      -20.137       4.3001
      -44.082      -8.9982       14.538       4.2683
       8.5191     -0.64761      0.74159       2.9678
        2.105      -3.1457      -13.612       2.4828
       -10.64      -17.231      -1.6043       4.4988
      -11.785       23.266      -36.159       4.1081
      -19.452       7.9364       19.511       3.2246
     -0.85916       23.057      -17.661       4.0899
       6.8282      -8.9591      -12.393       3.3011]);
   
P(2) = Polyhedron([
     46.882      -34.218       7.9751
      -31.824      -15.638       23.997
       -14.45       37.873      -22.288
      -17.716       83.043      -35.091
       56.691       8.0251      -6.4967
       2.8315      -9.3318      -36.891
      -37.837       24.559      -2.5039
      -39.358      -17.066       9.7719
       60.749       65.187       48.065
       67.811        38.74       6.2944
       57.227      -42.965      -18.971
      -43.958      -23.446       57.197
      -7.4738       46.933       28.883
      -6.9626       13.583       8.0766
       10.762       13.757       23.507
      -20.031      -59.757      -17.783 ]);

% intersect
R = intersect(P(1),P(2));

% R must be in P
if ~P.contains(R)
    error('R must be contained in P.');
end

% low-dim
T = Polyhedron('He',[randn(1,3) 0],'H',R.H,'V',R.V);

% V-rep
S = Polyhedron('V',T.V,'R',T.R);

% S must be in R
if ~R.contains(S)
    error('R must be contained in S.');
end

% S must be contained in both P
if ~P.contains(S)
    error('S must contained in both P.')
end


end
