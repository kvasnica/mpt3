function test_polyhedron_convexHull_14_pass
%
% add equalities 
%

H=[
   -1.8         0.5            4
   1            -1            1;  % redundant
   -4           0           0.8;
   0.9          -1            3;
   2            -2            2; % redundant
   ];
He = [ 1 -1 0];
        
P = Polyhedron('H',H,'He',He);
       
% count number of vertices
P.computeVRep();
nV = size(P.V,1);


P.minHRep();


if size(P.H,1)~=nV
    error('Number of vertices does not hold with number of inequalities.');
end

end
