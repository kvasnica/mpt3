function test_union_removeAllFunctions_01_pass
%
% empty union
%
U = Union;

U.removeAllFunctions;


s = U.listFunctions;

if ~isempty(s)
    error('No functions here.');
end

end
