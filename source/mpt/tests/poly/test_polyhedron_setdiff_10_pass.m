function test_polyhedron_setdiff_10_pass
%
% set difference between full dimensional polyhedron and lower dimensional between
% unbounded, low-dim
%


H1 = [ 0.70888      0.33158            1
      -1.6178        1.355            1
       1.1967       1.0315            1
       1.1696       2.1592            1
     -0.39951       -1.035            1
      -1.2932       -0.273            1];

% full-dim
P(1) = Polyhedron('H',H1);

% low-dim
P(2) = Polyhedron('lb',[-1;-1.4],'ub',[2;3],'He',[-0.5 1 -1]);

% unbounded
Q(1) = Polyhedron('H',[ -1 1 -3]);

% low-dim
Q(2) = Polyhedron('lb',[-1;-1],'ub',[1;1],'He',[0 1 0]);



R = P\Q;
% % result are 2 full-dim polytopes and 1 low-dime
% H{1} = [-1.6178        1.355            1
%        1.1967       1.0315            1
%        1.1696       2.1592            1
%             0           -1            0];
% He{1} = [];
% 
% H{2} = [-1.6178        1.355            1
%        1.1967       1.0315            1
%      -0.39951       -1.035            1
%       -1.2932       -0.273            1
%             1           -1            3
%             0            1            0];
% He{2} = [];
% 
% H{3} = [ 0           -1          1.4
%             1            0            2];
% 
% He{3} = [-0.5            1           -1];
%      
% % since the result can be arbitrarily ordered, we need to test each combination 
% ts = false(3);
% for i=1:3
%     for j=1:3
%       ts(i,j) = Polyhedron('H',H{i},'He',He{i}) == R(j);
%     end
% end

H{1} = [   1                        -1                         3
         -1.6178                     1.355                         1
          1.1967                    1.0315                         1
          1.1696                    2.1592                         1
        -0.39951                    -1.035                         1
         -1.2932                    -0.273                         1];
He{1} = [];
H{2} = [ 0                        -1                       1.4
         1                         0                         2];
He{2} = [  -0.5                         1                        -1];


ts = false(2);
for i=1:2
    for j=1:2
      ts(i,j) = Polyhedron('H',H{i},'He',He{i}) == R(j);
    end
end

if any(sum(ts,2)>1)
    error('Here should be 2 regions.');
end


end
