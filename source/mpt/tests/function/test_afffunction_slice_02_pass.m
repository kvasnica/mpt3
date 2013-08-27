function test_afffunction_slice_02_pass
% tests AffFunction/slice()

F = [1 2 3; 4 5 6];
g = [7; 8];
fun = AffFunction(F, g);

dims = [1 3]; 
values = [-1 2];

other = setdiff(1:size(F, 2), dims);
Fn = F(:, other);
gn = g + F(:, dims)*values(:);

new = fun.slice(dims, values);
assert(isa(new, 'AffFunction'));
assert(isequal(new.F, Fn));
assert(isequal(new.g, gn));
assert(new.R==size(F, 1));
assert(new.D==numel(other));

end
