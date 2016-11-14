function test_polyhedron_50_pass
% prevent out-of-memory issues by keeping matrices sparse (issue #128)

% the following code would out-of-memory without a fix
P = Polyhedron(sprandn(8000,8000,1e-3), ones(8000,1));
P = Polyhedron('A', sprandn(8000,8000,1e-3), 'b', ones(8000,1));

end
