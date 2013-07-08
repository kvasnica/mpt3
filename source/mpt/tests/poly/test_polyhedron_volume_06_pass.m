function test_polyhedron_volume_06_pass
% issue #71: trivial 1D cases used to fail due to a bug in convhulln()

P = Polyhedron('lb', -5, 'ub', -3);
V = P.volume();
assert(V==2);

end
