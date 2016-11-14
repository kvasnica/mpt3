function test_polyhedron_randomPoint_02_pass
% tests Polyhedron/randomPoint with valid inputs

% H-polyhedron
P = Polyhedron([eye(2); -eye(2)], ones(4, 1));
for i = 1:50
    x = P.randomPoint();
    assert(P.contains(x));
end

% V-polyhedron
P = Polyhedron(randn(10, 3));
for i = 1:50
    x = P.randomPoint();
    assert(P.contains(x));
end

end