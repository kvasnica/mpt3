function test_polyhedron_integrate_02_pass
% basic 1D tests

P = Polyhedron('lb', -1, 'ub', 2);
vol = P.volume();
assert(vol==3);
const = 2.5;
lin = 1;
quad = 1.5;
P.addFunction(AffFunction(0, const), 'const1');
P.addFunction(QuadFunction(0, 0, const), 'const2');
P.addFunction(AffFunction(lin, const), 'lin');
P.addFunction(QuadFunction(quad, lin, const), 'quad');

% constant function = scaled volume
I = P.integrate('const1');
Igood = const*vol;
assert(abs(I - Igood) <= 1e-6);
I = P.integrate('const2');
Igood = const*vol;
assert(abs(I - Igood) <= 1e-6);

% linear function
I = P.integrate('lin');
Igood = 9;
assert(abs(I - Igood) <= 1e-6);

% quadratic function
I = P.integrate('quad');
Igood = 27/2;
assert(abs(I - Igood) <= 1e-6);

end
