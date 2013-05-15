function test_polyhedron_setdiff_01_pass
%
% set difference between two full-dimensional polyhedra-simple 
%

A1 = [  -1.2814      0.68501
       3.2207       1.4836
      0.46869      -2.3257
     0.033593      0.86382
      0.74586      0.23698
     -0.34968      -1.2766
     -0.17177     -0.41702
       1.5186      0.17417
       1.7997       3.3987
       1.7175       2.5939];
b = ones(10,1);

P = Polyhedron(A1,b);

A2 = [-1.046      -2.7953
     -0.73874       1.6105
     -0.65077      0.45892
      0.15259     -0.79919
    -0.024847       1.4012
      0.44342       -1.831
     -0.89147     0.070524
       1.0792     -0.45755
       1.1103      0.10768
      0.85456      0.15133];

Q = Polyhedron(A2,b);

R = P\Q;

% R is an array of 2 polyhedra
H{1} = [-1.2814      0.68501            1
      0.46869      -2.3257            1
     -0.34968      -1.2766            1
        1.046       2.7953           -1];
H{2} = [-1.2814      0.68501            1
       1.7997       3.3987            1
      0.73874      -1.6105           -1];

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