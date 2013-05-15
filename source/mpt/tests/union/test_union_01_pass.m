function test_union_01_pass
%
% empty union object
%

U = Union;

if U.Num~=0
    error('must be empty');
end

end