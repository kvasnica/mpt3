function test_polyhedron_extreme_03_pass
%
% V-H representation that does not hold
%

% V -representation builds a triangle
PV = Polyhedron('V',[1 1;-1 -1;1 -1]);

% H -representation builds an unbounded polyhedron
PH = Polyhedron('H',[1 -1 0.5; 0.5 -5 2; 4 -0.5 1; 0.8 -9.1 3.5]);

% what is the result of both representations?
P = Polyhedron('V',[1 1;-1 -1;1 -1],'H',[1 -1 0.5; 0.5 -5 2; 4 -0.5 1; 0.8 -9.1 3.5]);

% compute H-rep
P.minHRep();

% take the convex hull
U = PolyUnion([PV, PH]);
C = U.convexHull;

% R is the union of H- and V-representations
R=Polyhedron('R',[1  8; -11.375  -1],'V',[1 -1]);

if C~=R
    error('C and R must be the same.');
end

% R and P must be the same
if R~=P
    error('Test on incompatible H- and V-representation failed, R and P must be the same.');
end

end
