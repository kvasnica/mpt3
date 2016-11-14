function test_polyhedron_fplot_06_pass
%
% 1D-H-V array of polyhedra, affine function, quadratic function
%

P(1) = Polyhedron('lb',-1,'ub',5);
P(2) = Polyhedron('V',[-5;-3; 2;1]);

L = AffFunction(5,-4);
Q = QuadFunction(6,-1,2);
P.addFunction(L,'gain');
P.addFunction(Q,'skew');

figure
h = P.fplot('gain');
assert(numel(h)==2);

figure
h = P.fplot('skew');
assert(numel(h)==2);

end
