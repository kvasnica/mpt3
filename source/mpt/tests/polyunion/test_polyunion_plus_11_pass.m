function test_polyunion_plus_11_pass
% PolyUnion+Polyhedron, Polyhedron+PolyUnion

P1 = Polyhedron.unitBox(2)+[-1; 0];
P2 = Polyhedron.unitBox(2)+[1; 0];
P = Polyhedron.unitBox(2)*0.5;
U = PolyUnion([P1 P2]);

% PolyUnion+Polyhedron
Z = U+P;
Zexp = Polyhedron('lb', [-2.5; -1.5], 'ub', [2.5; 1.5]);
assert(Z==Zexp);

% Polyhedron+PolyUnion: currently unsupported
Z = P+U;
Zexp = Polyhedron('lb', [-2.5; -1.5], 'ub', [2.5; 1.5]);
assert(Z==Zexp);

end
