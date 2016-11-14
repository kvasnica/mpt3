function test_polyunion_slice_02_pass
% PolyUnion/slice for multiple inputs

P1 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
P1.addFunction(AffFunction([1 1], 1), 'f');
P2 = Polyhedron('lb', [1; -1], 'ub', [2; 1]);
P2.addFunction(AffFunction([1 -1], 1), 'f');
U1 = PolyUnion([P1 P2]);
U2 = PolyUnion([P1 P2]);
U = [U1 U2];

% PolyUnion/slice does not support multiple polyunions:
[~, msg] = run_in_caller('S = U.slice(2, 0.5);');
asserterrmsg(msg, 'This method does not support arrays. Use the forEach() method.');

% manual slicing via forEach():
S = U.forEach(@(x) x.slice(2, 0.5));
assert(numel(S)==2);
assert(isa(S(1), 'PolyUnion'));
assert(isa(S(2), 'PolyUnion'));
assert(S(1).Num==2);
assert(S(1).hasFunction('f'));
assert(S(1).Set(1).Functions('f').D==1);
assert(S(2).Num==2);
assert(S(2).hasFunction('f'));
assert(S(2).Set(1).Functions('f').D==1);

end
