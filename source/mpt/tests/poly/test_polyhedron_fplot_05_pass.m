function test_polyhedron_fplot_05_pass
%
% H-V array of polyhedra, linear function
%

P(1) = Polyhedron('lb',[-4;-1],'ub',[5;0]);
P(2) = Polyhedron('V',randn(5,2))+[5;3];

L = AffFunction(5*eye(2));
P.addFunction(L,'gain');

% must get two handles
h = P.fplot();
assert(isa(h, 'double'));
assert(numel(h)==2);

end
