function test_polyhedron_fplot_09_pass
%
% 2D zonotope
%

P = ExamplePoly.randZono;

Q = QuadFunction(randn(2));
P.addFunction(Q, 'q');


P.fplot('q');

close

end
