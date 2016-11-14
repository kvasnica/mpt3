function test_polyhedron_convexHull_15_pass
%
% add random equalities and inequalities
%

H=[
   -1.8         0.5            4;
   1            -1            1;  % redundant
   -4           0           0.8;
   randn(2) ones(2,1);
   2            -2            2]; % redundant

He = randn(1, 3);
        
P = Polyhedron('H',H,'He',He);
       
% count number of vertices
P.computeVRep();
nV = size(P.V,1);


P.minHRep();

if all(P.V==0) % isempty
    %if size(P.H,1)~=size(H,1)
    if ~P.isEmptySet
        error('Polyhedron should be empty, i.e. the H-representation is not changed.');
    end
else
    if size(P.H,1)~=nV
        error('Number of vertices does not hold with number of inequalities.');
    end
end

end
