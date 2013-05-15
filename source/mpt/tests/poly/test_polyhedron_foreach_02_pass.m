function test_polyhedron_foreach_02_pass
% forEach witth non-uniform outputs

% forEach with non-uniform outputs
P = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
Q = Polyhedron([0 0; 0 1; 1 0]);
Z = [P Q];
% forEach must fail gracefuly if non-uniform outputs are detected and
% UniformOutput=true (default)
[worked, msg] = run_in_caller('out=Z.forEach(@triangulate);');
assert(~worked);
assert(~isempty(strfind(msg, 'Non-scalar in Uniform output, at index 1, output 1.')));
% pass if UniformOutput=false
out = Z.forEach(@triangulate, 'UniformOutput', false);
assert(iscell(out));
assert(length(out)==2);
assert(isa(out{1}, 'Polyhedron'));
assert(isa(out{2}, 'Polyhedron'));
assert(length(out{1})==2); % because P is a square
assert(length(out{2})==1); % because Q is a simple
assert(out{1}==P.triangulate);
assert(out{2}==Q.triangulate);

% forEach applied to getters
P = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
Q = Polyhedron([0 0; 0 1; 1 0]);
Z = [P Q];
% non-uniform outputs here, hence the default must fail
[worked, msg] = run_in_caller('out=Z.forEach(@(x) x.A);');
assert(~worked);
assert(~isempty(strfind(msg, 'Non-scalar in Uniform output, at index 1, output 1.')));
% pass if UniformOutput=false
out = Z.forEach(@(x) x.A, 'UniformOutput', false);
assert(iscell(out));
assert(length(out)==2);
assert(isequal(out{1}, P.A));
assert(isequal(out{2}, Q.A));

end
