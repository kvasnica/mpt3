function test_polyhedron_setdiff_04_pass
%
% set difference between unbounded polyhedron and full-dimensional polyhedron in 2D
%

H1 = [ 1.527       1.6821       5.6053
      -1.0298     -0.19224      -1.3985
      0.94922     -0.27407      0.70834
      0.51525      -1.0642      -1.0859
     -0.94149       1.2347       1.4251];

P = Polyhedron('H',H1);

H2 = [-0.6573      0.11339     -0.46247
       1.4705      -1.4617     -0.84597];


Q = Polyhedron('H',H2);

R = Q\P;

H{1} = [-0.6573      0.11339     -0.46247
       1.4705      -1.4617     -0.84597
       -1.527      -1.6821      -5.6053]; 
H{2} = [-0.6573      0.11339     -0.46247
       1.4705      -1.4617     -0.84597
       1.0298      0.19224       1.3985];   
H{3} = [1.4705      -1.4617     -0.84597
        1.527       1.6821       5.6053
     -0.94922      0.27407     -0.70834];
H{4} = [-0.6573      0.11339     -0.46247
        1.527       1.6821       5.6053
      0.94149      -1.2347      -1.4251];
  
% since the result can be arbitrarily ordered, we need to test each combination 
ts = false(4);
for i=1:4
    for j=1:4
      ts(i,j) = Polyhedron('H',H{i}) == R(j);
    end
end

if any(sum(ts,2)>1)
    error('Here should be 2 non-overlapping regions.');
end

end