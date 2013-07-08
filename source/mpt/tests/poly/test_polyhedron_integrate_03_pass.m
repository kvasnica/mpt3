function test_polyhedron_integrate_03_pass
% 2D case

P = Polyhedron('lb', [0; 0], 'ub', [2; 2]);
vol = P.volume();
const = 2.5;
lin = [1 1];
quad = diag([1 2]);
P.addFunction(AffFunction(0*lin, const), 'const1');
P.addFunction(QuadFunction(0*quad, 0*lin, const), 'const2');
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
Igood = 18;
assert(abs(I - Igood) <= 1e-6);

% quadratic function
I = P.integrate('quad');
Igood = 34;
assert(abs(I - Igood) <= 1e-6);

end
