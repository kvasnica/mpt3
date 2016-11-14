function test_polyhedron_plus_20_pass
% addition where one polyhedron is a single vertex

% this used to fail for d>4 due to faulty projection
for d = 1:5
    P = Polyhedron.unitBox(d);
    Q = Polyhedron('lb', 0*ones(P.Dim, 1), 'ub', 0*ones(P.Dim, 1));
    Z = P+Q;
    assert(~Z.isEmptySet());
    assert(Z==P);
end


end