function test_union_plot_01_pass
% plot multiple unions (combination of YSets and Polyhedra)

x1 = sdpvar(2, 1);
x2 = sdpvar(2, 1);
Y1 = YSet(x1, [x1'*x1 <= 1]);
Y2 = YSet(x2, [0 <= x2 <= 1.5]);
P1 = Polyhedron('lb', [-1; -1], 'ub', [0; 0]);
P2 = Polyhedron('lb', [0.5; 0.5], 'ub', [2; 1]);
P3 = Polyhedron('lb', [3; 3], 'ub', [4; 4]);

U1 = Union;
U1.add(Y1);
U1.add(P1);
U2 = Union;
U2.add(Y2);
U2.add(P2);
U2.add(P3);

h = plot(U1);
assert(numel(h)==2);
h = plot(U2);
assert(numel(h)==3);

h = plot(U1, U2);
assert(numel(h)==5);

h = plot(U1, 'color', 'g', U2, 'color', 'b');
assert(numel(h)==5);

h = plot(U1, 'color', 'g', U2, 'color', 'b', [U1 U2]);
assert(numel(h)==10);

h = plot([U1 U2]);
assert(numel(h)==5);

close

end
