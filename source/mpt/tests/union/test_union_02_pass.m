function test_union_02_pass
%
% empty union array
%

U = [Union;Union];

for i=1:2
    if U(i).Num~=0
        error('must be empty');
    end
end

end