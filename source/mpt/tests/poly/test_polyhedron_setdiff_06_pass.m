function test_polyhedron_setdiff_06_pass
%
% set difference between unbounded polyhedron and unbounded polyhedron in
% 2D
%

H1 = [-0.39726      -1.9055     -0.29395
      0.53786      -1.0767    -0.038178
       1.7697       1.1949      0.92393];

P = Polyhedron('H',H1);

H2 = [-0.19767      -1.6462     0.092215
     -0.75597      -1.2898     -0.10096
       0.1212     -0.39985     0.085671
      -1.4958       0.7754     0.032529];


Q = Polyhedron('H',H2);

R = P\Q;

% result should be one unbouded polyhedron- but since the algorithm
% operates with all facets, two polyhedra are generated (which form convex
% union)
H{1} = [-0.39726      -1.9055     -0.29395
      0.75597       1.2898      0.10096]; 
H{2} = [-0.39726      -1.9055     -0.29395
       1.7697       1.1949      0.92393
     -0.75597      -1.2898     -0.10096
       1.4958      -0.7754    -0.032529];   
 
% since the result can be arbitrarily ordered, we need to test each combination 
ts = false(2);
for i=1:2
    for j=1:2
      ts(i,j) = Polyhedron('H',H{i}) == R(j);
    end
end

if any(sum(ts,2)>1)
    error('Here should be 2 non-overlapping regions.');
end

% the result here should be 1 polytope and 2 unbounded polyhedra
T = Q\P;

Hn{1} =[-0.19767      -1.6462     0.092215
     -0.75597      -1.2898     -0.10096
       0.1212     -0.39985     0.085671
      -1.4958       0.7754     0.032529
      0.39726       1.9055      0.29395];
  
Hn{2} = [0.1212     -0.39985     0.085671
     -0.39726      -1.9055     -0.29395
     -0.53786       1.0767     0.038178];

Hn{3} = [-1.4958       0.7754     0.032529
      0.53786      -1.0767    -0.038178
      -1.7697      -1.1949     -0.92393];

tn = false(3);
for i=1:3
    for j=1:3
      tn(i,j) = Polyhedron('H',Hn{i}) == T(j);
    end
end

if any(sum(tn,2)>1)
    error('Here should be 3 non-overlapping regions.');
end
  
  
end