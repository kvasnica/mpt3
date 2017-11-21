function test_polyhedron_barycoords_01
% tests for Polyhedron/barycentricCoordinates()

for d = 2:4
    P = Polyhedron.unitBox(d) + randn(d, 1)*5;
    [b, bi, wi] = P.barycentricCoordinates();
    assert(isa(b, 'function_handle'));
    assert(iscell(bi));
    for i = 1:length(bi)
        assert(isa(bi{i}, 'function_handle'));
    end
    X = [P.V; P.chebyCenter().x'];
    for i = 1:size(X, 1)
        x0 = X(i, :)';
        assert(all(b(x0))>=0, 'non-negativity check failed');
        assert(abs(sum(b(x0))-1)<1e-5, 'partition of unity check failed');
        assert(norm(P.V'*(b(x0)')-x0)<1e-5, 'linear precision check failed');
    end
end

end
