function test_polyhedron_trim_02_pass
% tests ConvexSet/trimFunction

P = Polyhedron('lb', -1, 'ub', 1);
fun = AffFunction(zeros(3, 1), [1; 2; 3]);
P.addFunction(fun, 'f');

P.trimFunction('f', 2);
f = P.Functions('f');
assert(isequal(f.g, [1; 2]));

end
