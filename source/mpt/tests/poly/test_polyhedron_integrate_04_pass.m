function test_polyhedron_integrate_04_pass
% arrays

P1 = Polyhedron('lb', -1, 'ub', 2);
P2 = Polyhedron('lb', 3, 'ub', 4.5);
c1 = 2.5;
c2 = 5;
P1.addFunction(AffFunction(0, c1), 'const');
P2.addFunction(AffFunction(0, c2), 'const');
P = [P1, P2];

I = P.integrate();
Igood = [P1.volume*c1, P2.volume*c2];
assert(norm(I - Igood) <= 1e-6);

end
