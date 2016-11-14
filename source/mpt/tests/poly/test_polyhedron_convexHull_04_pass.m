function test_polyhedron_convexHull_04_pass
%
% 
% not redundant H representation
% 

% generate random vector
v = randn(1,5);
H = ones(15,6);

for i=1:15
   H(i,1:5) = v*i+i^2; % distinct values     
end


 P = Polyhedron('H',H);
 
 P.minHRep();
 
 if size(P.H,1)~=15
     error('Here should be only 15 inequalities left.');
 end
