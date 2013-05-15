function test_polyhedron_convexHull_02_pass
%
% 
% obviously redundant H representation
% 

H = [
    1:5
    1:5
    randn(1,5)
    randn(1,5)];

 P = Polyhedron('H',H);
 
 P.minHRep();
 
 if size(P.H,1)~=3
     error('Here should be only 3 inequalities left.');
 end
