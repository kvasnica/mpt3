function test_ltisystem_forwardreach_01_pass
% LTISystem/reachableSet with non-autonomous system (forward)

model = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
model.x.min = [-5; -5];
model.x.max = [5; 5];
model.u.min = -1;
model.u.max = 1;

% no direction provided, should assume forward reachability
S = model.reachableSet();
assert(isa(S, 'Polyhedron'));
assert(numel(S)==1);
Hgood = [-0.447213595499958 0.894427190999916 4.47213595499958;-0.707106781186547 0.707106781186547 3.88908729652601;0.447213595499958 -0.894427190999916 4.47213595499958;0 -1 5.5;0.707106781186547 -0.707106781186547 3.88908729652601;0 1 5.5];
assert(S==Polyhedron('H', Hgood));

% forward direction provided
S = model.reachableSet('direction', 'forward');
assert(isa(S, 'Polyhedron'));
assert(numel(S)==1);
Hgood = [-0.447213595499958 0.894427190999916 4.47213595499958;-0.707106781186547 0.707106781186547 3.88908729652601;0.447213595499958 -0.894427190999916 4.47213595499958;0 -1 5.5;0.707106781186547 -0.707106781186547 3.88908729652601;0 1 5.5];
assert(S==Polyhedron('H', Hgood));

% no N provided, use min/max constraints
S = model.reachableSet();
assert(isa(S, 'Polyhedron'));
assert(numel(S)==1);
Hgood = [-0.447213595499958 0.894427190999916 4.47213595499958;-0.707106781186547 0.707106781186547 3.88908729652601;0.447213595499958 -0.894427190999916 4.47213595499958;0 -1 5.5;0.707106781186547 -0.707106781186547 3.88908729652601;0 1 5.5];
assert(S==Polyhedron('H', Hgood));

% N=1, use min/max constraints
N = 1;
S = model.reachableSet('N', N, 'direction', 'f');
assert(isa(S, 'Polyhedron'));
assert(numel(S)==1);
Hgood = [-0.447213595499958 0.894427190999916 4.47213595499958;-0.707106781186547 0.707106781186547 3.88908729652601;0.447213595499958 -0.894427190999916 4.47213595499958;0 -1 5.5;0.707106781186547 -0.707106781186547 3.88908729652601;0 1 5.5];
assert(S==Polyhedron('H', Hgood));

% uses min/max constraints
N = 4;
[S, SN] = model.reachableSet('N', N);
assert(isa(S, 'Polyhedron'));
assert(numel(S)==1);
assert(iscell(SN));
assert(length(SN)==N);
for i = 1:N
	assert(isa(SN{i}, 'Polyhedron'));
	assert(numel(SN{i})==1);
end
Hgood = [-0.447213595499958 0.894427190999916 4.47213595499958;-0.707106781186547 0.707106781186547 3.88908729652601;0.447213595499958 -0.894427190999916 4.47213595499958;0 -1 5.5;0.707106781186547 -0.707106781186547 3.88908729652601;0 1 5.5];
assert(SN{1}==Polyhedron('H', Hgood));
Hgood = [0.196116135138184 -0.98058067569092 2.54950975679639;-0.447213595499958 0.894427190999916 8.04984471899924;0 -1 7;0.447213595499958 -0.894427190999916 8.04984471899924;0.316227766016838 -0.948683298050514 3.79473319220205;0.242535625036333 -0.970142500145332 1.69774937525433;-0.316227766016838 0.948683298050514 3.79473319220206;-0.196116135138184 0.98058067569092 2.54950975679639;0 1 7;-0.242535625036333 0.970142500145332 1.69774937525433];
assert(S==Polyhedron('H', Hgood));
assert(SN{N}==Polyhedron('H', Hgood));

% use provided X
X = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
N = 1;
S = model.reachableSet('N', N, 'X', X, 'direction', 'forw');
assert(isa(S, 'Polyhedron'));
assert(numel(S)==1);
Hgood = [-0.447213595499958 0.894427190999916 0.894427190999916;-0.707106781186547 0.707106781186547 1.06066017177982;0.447213595499958 -0.894427190999916 0.894427190999916;0 -1 1.5;0.707106781186547 -0.707106781186547 1.06066017177982;0 1 1.5];
assert(S==Polyhedron('H', Hgood));

% use provided U
U = Polyhedron('lb', -0.1, 'ub', 0.1);
N = 2;
[S, SN] = model.reachableSet('U', U, 'N', N, 'X', X);
assert(isa(S, 'Polyhedron'));
assert(numel(S)==1);
assert(iscell(SN));
assert(length(SN)==N);
for i = 1:N
	assert(isa(SN{i}, 'Polyhedron'));
	assert(numel(SN{i})==1);
end
Hgood = [0.316227766016838 -0.948683298050514 0.648266920334518;0 -1 1.1;-0.316227766016838 0.948683298050514 0.648266920334517;0 1 1.1;-0.447213595499958 0.894427190999916 0.469574275274956;0.447213595499958 -0.894427190999916 0.469574275274956];
assert(S==Polyhedron('H', Hgood));
assert(SN{N}==Polyhedron('H', Hgood));

end
