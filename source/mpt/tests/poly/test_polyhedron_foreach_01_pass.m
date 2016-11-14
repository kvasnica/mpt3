function test_polyhedron_foreach_01_pass
% forEach without outputs or with uniform outputs

% forEach with no outputs
P = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
Q = Polyhedron([0 0; 0 1; 1 0]);
Z = [P Q];
Z.forEach(@minHRep);
assert(P.irredundantHRep);
assert(Q.irredundantHRep);

% forEach with uniform outputs
P = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
Q = Polyhedron([0 0; 0 1; 1 0]);
Z = [P Q];
out = Z.forEach(@minHRep);
assert(isa(out, 'Polyhedron'));
assert(length(out)==2);
assert(out(1).irredundantHRep);
assert(out(2).irredundantHRep);

% test a different syntax
P = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
Q = Polyhedron([0 0; 0 1]); % lowdim
Z = [P Q Q P];
out = Z.forEach(@(x) x.isFullDim);
assert(isa(out, 'double') || islogical(out));
assert(length(out)==length(Z));
assert(length(out)==4); % double check :)
assert(isequal(out, [1 0 0 1]));

% forEach applied to a method which returns a structure
P = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
Q = Polyhedron('lb', [-4; -4], 'ub', [0; 0]);
Z = [P Q];
out = Z.forEach(@chebyCenter);
assert(length(out)==2);
assert(isstruct(out));
% use tolerance to increase robustness
assert(norm(out(1).x - [0; 0])<=1e-8);
assert(norm(out(1).r - 1)<=1e-8);
assert(norm(out(2).x - [-2; -2])<=1e-8);
assert(norm(out(2).r - 2)<=1e-8);

% multiple uniform outputs
P = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
Q = Polyhedron('lb', [-4; -4], 'ub', [0; 0]);
R = Polyhedron('lb', [1; -1], 'ub', [2; 1]);
Z = [P Q R];
[A, B, C] = Z.forEach(@(x) P.isAdjacent(x));
assert(isequal(A, [0 0 1]));  % P is adjacent to R
% it wouldn't make sense to test exact values of B and C, since those would
% depend on a solver
assert(isa(B, 'double'));
assert(isa(C, 'double'));
assert(length(B)==3);
assert(length(C)==3);

% we must get non-uniform outputs if we ask for
[A, B] = Z.forEach(@(x) x.isAdjacent(P), 'UniformOutput', false);
assert(iscell(A));
assert(iscell(B));
assert(length(A)==3);
assert(length(B)==3);
assert(isequal(cat(2, A{:}), [0 0 1]));

end
