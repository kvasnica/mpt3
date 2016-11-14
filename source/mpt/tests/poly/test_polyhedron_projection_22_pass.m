function test_polyhedron_projection_22_pass
% projection of a lower-dimensional polyhedron (mplp fails)

P = Polyhedron.unitBox(5);
Q = Polyhedron('lb', zeros(P.Dim, 1), 'ub', zeros(P.Dim, 1));

% default projection method (mplp must be avoided)
Z = Polyhedron([P.A 0*P.A; 0*Q.A Q.A], [P.b; Q.b]);
W = Z.projection(1:P.Dim);
assert(W==P);

end