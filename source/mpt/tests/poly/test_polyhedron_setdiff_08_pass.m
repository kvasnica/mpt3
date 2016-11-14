function test_polyhedron_setdiff_08_pass
%
% set difference between full dimensional polyhedron and 2 low-dimensional
% polyhedra in 2D
%

H1 = [1.3983     0.083714      0.45134
      0.40383       1.5778       2.3794
      -1.0272     -0.35789      0.89038];

% full-dim
P = Polyhedron('H',H1);

Pn(1) = Polyhedron('H',[ -0.56439, -2.4432, 1; -0.49554, 2.4516, 1],'He',[1, 1, 0]);
Pn(2) = Polyhedron('H',[0.38547, -0.51851, 2; -0.11242, 1.6207, 2],'He',[2, -1, 0.5]);

% full-dim\low-dim
R = P\Pn;

% P\Q where P is full-dim and Q is low-dim is equal to P unless we can
% support open half-spaces
assert(numel(R)==1)
assert(R==P);

% % result are 4 full-dim polytopes
% H{1} = [1.3983     0.083714      0.45134
%            -1           -1            0
%            -2            1         -0.5];
% H{2} = [1.3983     0.083714      0.45134
%       0.40383       1.5778       2.3794
%       -1.0272     -0.35789      0.89038
%            -1           -1            0
%             2           -1          0.5];
% H{3} = [1.3983     0.083714      0.45134
%       -1.0272     -0.35789      0.89038
%             1            1            0
%            -2            1         -0.5];
% H{4} = [-1.0272     -0.35789      0.89038
%             1            1            0
%             2           -1          0.5];
%      
% % since the result can be arbitrarily ordered, we need to test each combination 
% ts = false(2);
% for i=1:4
%     for j=1:4
%       ts(i,j) = Polyhedron('H',H{i}) == R(j);
%     end
% end
% if any(sum(ts,2)>1)
%     error('Here should be 4 non-overlapping regions.');
% end

end
