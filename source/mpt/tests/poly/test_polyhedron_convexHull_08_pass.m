function test_polyhedron_convexHull_08_pass
%
% 
% V representation, H is empty, call cddmex
% 

V = [0 -1 2 3 4;
    -1 -1 0.6 8 1;
    2 4 6 9 -1;
    0 0 0 3 5;
    -1 -5 -5.5 0 -7.3;
    8 -0.3 0 0 5];

P = Polyhedron(V);


P.minHRep();

if size(P.H,1)~=6
    error('H-rep must have 6 rows.');
end
