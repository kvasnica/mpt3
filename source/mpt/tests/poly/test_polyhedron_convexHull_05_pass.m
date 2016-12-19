function test_polyhedron_convexHull_05_pass
%
% 
% not redundant H representation
% 

H = [1 0.6 3 0.1;
    -4 -2 6 -4;
    7 0.6 -5 1];

P = Polyhedron('H',H);

P.minHRep();
    

 
 if size(P.H,1)~=3
     error('Here should be only 15 inequalities left.');
 end

end
