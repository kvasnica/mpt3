function test_union_copy_01_pass
% copying of empty unions

U = Union;
C = U.copy();
assert(isa(U, 'Union'));
assert(isa(C, 'Union'));

end
