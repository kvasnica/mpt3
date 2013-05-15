function test_polyhedron_setdiff_07_pass
%
% set difference between lower dimensional polyhedron and full-dimensional
% and vice-versa in 2D
%

H1 = [-0.53701       -0.657     -0.55454
      -1.0402      0.67775      -5.7101
      0.99728     -0.51083       6.3783
    -0.026054        0.446     -0.63905];

% full-dim
P = Polyhedron('H',H1);

H2 = [-1     0    -2
     1     0     6];
He = [ -1     2    -8];

% low-dim
Q = Polyhedron('H',H2,'He',He);


% full-dim\low-dim
R = P\Q;

% P\Q where P is full-dim and Q is low-dim is equal to P unless we can
% support open half-spaces
assert(numel(R)==1)
assert(R==P);

% % result are 2 full-dim polytopes
% H{1} = [-1.0402      0.67775      -5.7101
%     -0.026054        0.446     -0.63905
%             1           -2            8];
% 
% H{2} = [-0.53701       -0.657     -0.55454
%       -1.0402      0.67775      -5.7101
%       0.99728     -0.51083       6.3783
%     -0.026054        0.446     -0.63905
%            -1            2           -8];
% % since the result can be arbitrarily ordered, we need to test each combination 
% ts = false(2);
% for i=1:2
%     for j=1:2
%       ts(i,j) = Polyhedron('H',H{i}) == R(j);
%     end
% end
% if any(sum(ts,2)>1)
%     error('Here should be 2 non-overlapping regions.');
% end

% low-dim\full-dim
T = Q\P;

% result should be 2 low-dim polyhedra, but the algorithm decomposes them
% to 4 low-dim polyhedra
Hn{1} =[-1            0           -2
      0.53701        0.657      0.55454];
  
Hn{2} = [-0.53701       -0.657     -0.55454
       1.0402     -0.67775       5.7101];

Hn{3} = [1            0            6
     -0.99728      0.51083      -6.3783];

Hn{4} = [0.99728     -0.51083       6.3783
     0.026054       -0.446      0.63905];

tn = false(4);
for i=1:4
    for j=1:4
      tn(i,j) = Polyhedron('H',Hn{i},'He',He) == T(j);
    end
end

if any(sum(tn,2)>1)
    error('Here should be 4 non-overlapping regions.');
end
  
  
end
