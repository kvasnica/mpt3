function test_polyhedron_distance_02_pass
%
% 3D polyhedron, S is a real vector
%

P = Polyhedron([
      3.6517       1.4101       6.5053
      0.14803       3.2456      0.07889
       6.5713       7.4838       1.1111
       3.5576       7.3352       1.6221
       4.9235       3.2822       1.5898
       6.3355       7.1492       4.8303
       7.3745      0.46313       2.1775
       5.9057       2.8229       1.5905]);
S = [3;1;2];

s = P.distance(S);

if norm(s.dist-0.98399)>1e-4
    error('Wrong distance.');
end

end