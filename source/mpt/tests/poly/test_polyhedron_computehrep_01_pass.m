function test_polyhedron_computehrep_01_pass
% Polyhedron/computeHRep often fails in high dimensions

for d = 1:5
    P = Polyhedron.unitBox(d);
    Z = Polyhedron(P.V);
    Z.computeHRep();
    Q = Polyhedron(Z.A, Z.b);
    assert(Q==P);
    assert(Z==P);
end

end