function test_polytope_subsasgn_01_pass

p1 = polytope([1; -1], [1;1]);
p2 = polytope([1; -1], [2;2]);
array(1) = p1;
array(2) = p2;
assert(isequal(double(array(1)), [1 1; -1 1]));
assert(isequal(double(array(2)), [1 2; -1 2]));

end
