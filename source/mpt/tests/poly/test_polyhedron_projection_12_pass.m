function test_polyhedron_projection_12_pass
%
% test by michal - problem is caused by CDD solver that computes wrong H-V
% representaion
%

A = [-1 0 0; 0 -1 0]; b = [0; 0];
Q = Polyhedron('A', A, 'b', b);
P = Polyhedron('A', A, 'b', b);
Z = P.projection(1:2);
if ~(Q==P)
    error('Obviously wrong output.');
end
if size(Q.H, 2) ~= size(P.H, 2)
    error('Projection has misteriously added a half-space to the original polytope.');
end

% result as given by mpt2
Qn = Polyhedron([-1 0;0 -1],[0;0]);

if Qn~=Z
    error('The polyhedra should be the same.');
end

end