function test_union_removeFunction_01_pass
%
% no function
%

U = Union;

U.removeFunction();

s = U.listFunctions;

if ~isempty(s)
    error('There are no functions here.');
end
end
