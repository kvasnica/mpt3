function test_polyhedron_setdiff_03_pass
%
% set difference between full-dimensional and unbounded polyhedron - 2D
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

R = P\Q;

H{1} = [-1.0298     -0.19224      -1.3985
      -0.94149       1.2347       1.4251
       0.6573     -0.11339      0.46247]; 
H{2} = [-1.0298     -0.19224      -1.3985
      0.94922     -0.27407      0.70834
      0.51525      -1.0642      -1.0859
      -1.4705       1.4617      0.84597];   

% since the result can be arbitrarily ordered, we need to test each combination 
ts = false(2);
for i=1:2
    for j=1:2
      ts(i,j) = Polyhedron('H',H{i}) == R(j);
    end
end

if any(sum(ts,2)>1)
    error('Here should be 2 regions.');
end

end