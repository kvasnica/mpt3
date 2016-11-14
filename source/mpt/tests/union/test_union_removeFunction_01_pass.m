function test_union_removeFunction_01_pass
%
% no function
%

U = Union;
U = U([]);
U.removeFunction('one');
s = U.listFunctions;
assert(isempty(s));

end
