function test_polyhedron_fplot_01_pass
%
% polyhedron - one function
%

P = ExamplePoly.randHrep;
while ~P.isBounded
    P = ExamplePoly.randHrep;
end
L = AffFunction([0 0; 2 3], randn(2,1));
P.addFunction(L, 'a');

% plots the only function, position=1
P.fplot();
% explicit function name
P.fplot('a');
% position
P.fplot('position', 2);
% name + position
P.fplot('a', 'position', 1);

% handles must be returned
h=P.fplot;
assert(isscalar(h));
h=P.fplot('a');
assert(isscalar(h));
h=P.fplot('position', 2);
assert(isscalar(h));
h=P.fplot('a', 'position', 1);
assert(isscalar(h));

close

end
