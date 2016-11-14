function test_polyunion_slice_01_pass
% tests PolyUnion/slice

P1 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
P1.addFunction(AffFunction([1 1], 1), 'f')
P2 = Polyhedron('lb', [1; -1], 'ub', [2; 1]);
P2.addFunction(AffFunction([1 -1], 1), 'f')
U = PolyUnion([P1 P2]);

% no slices here:
dim = 1;
value = -10;
S = U.slice(dim, value);
assert(S.Num==0);

% only one set in this slice:
dim = 1;
value = 0.5;
S = U.slice(dim, value);
assert(S.Num==1);
% functions must be preserved and sliced
assert(S.hasFunction('f'));
assert(S.Set(1).Functions('f').D==1);

% two sets in this slice:
dim = 2;
value = 0.5;
S = U.slice(dim, value);
assert(S.Num==2);
% functions must be preserved and sliced
assert(S.hasFunction('f'));
assert(S.Set(1).Functions('f').D==1);

end
