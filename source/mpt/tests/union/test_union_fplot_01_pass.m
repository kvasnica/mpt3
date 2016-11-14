function test_union_fplot_01_pass
%
% Polyhedron + YSet

P1 = Polyhedron('lb', -1, 'ub', 1);
P1.addFunction(@(x) x^3, 'f');
x = sdpvar(1, 1);
P2 = YSet(x, [1 <= x <= 2]);
P2.addFunction(@(x) x^2, 'f');
U = Union;
U.add(P1);
U.add(P2);

% U.Set must be a cell, which requires a different way of plotting
assert(iscell(U.Set));
h = U.fplot();
assert(isnumeric(h) | isa(h, 'matlab.graphics.primitive.Line'));
assert(numel(h)==2);

% now plot also the underlying sets
h = U.fplot('show_set', true);
assert(isnumeric(h) | isa(h, 'matlab.graphics.primitive.Data'));
assert(numel(h)==4);

end
