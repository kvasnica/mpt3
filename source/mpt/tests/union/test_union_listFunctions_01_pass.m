function test_union_listFunctions_01_pass
%
% no functions
%

U = Union;

s1 = U.listFunctions;

if ~isempty(s1) 
    error('No functions here.');    
end

Up = PolyUnion;

s2 = Up.listFunctions;

if ~isempty(s2) 
    error('No functions here.');    
end


end