function test_polyhedron_convexHull_03_pass
%
% 
% obviously redundant H representation
% 3 same rows
% 

v = 1:5;
H = [
    v;
    v*0.5;
    0.1 -3 0.5 6 -1;
    1 0.6 -1 0.5 3;
    v*rand(1);
    ];

 P = Polyhedron('H',H);
 
 P.minHRep();
 
 if size(P.H,1)~=3
     error('Here should be only 3 inequalities left.');
 end

 end
