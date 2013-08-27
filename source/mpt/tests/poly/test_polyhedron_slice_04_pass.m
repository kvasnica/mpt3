function test_polyhedron_slice_04_pass
% tests Polyhedron/slide with functions

F = [1 2 3; 4 5 6];
g = [7; 8];
aff = AffFunction(F, g);
H = [1 2 3; 4 5 6; 7 8 9];
F = [1 2 3];
g = 1;
quad = QuadFunction(H, F, g);
P = Polyhedron('lb', [-3; -3; -3], 'ub', [3; 3; 3]);
P.addFunction(aff, 'aff');
P.addFunction(quad, 'quad');

dims = [3 2]; 
values = [-1 2];
keep = setdiff(1:size(F, 2), dims);
aff_Fs = aff.F(:, keep);
aff_gs = aff.g + aff.F(:, dims)*values(:);

S = P.slice(dims, values);
assert(S.hasFunction('aff'));
assert(S.hasFunction('quad'));
aff_s = S.Functions('aff');
quad_s = S.Functions('quad');

assert(isa(aff_s, 'AffFunction'));
assert(isequal(aff_s.F, aff_Fs));
assert(isequal(aff_s.g, aff_gs));
assert(aff_s.R==aff.R);
assert(aff_s.D==numel(keep));

assert(isa(quad_s, 'QuadFunction'));
assert(isequal(quad_s.H, 1));
assert(isequal(quad_s.F, 3));
assert(isequal(quad_s.g, 3));

dims = 3;
values = 1;
S = P.slice(dims, values);
quad_s = S.Functions('quad');
assert(isequal(quad_s.H, [1 2; 4 5]));
assert(isequal(quad_s.F, [11 16]));
assert(isequal(quad_s.g, 13));


end
