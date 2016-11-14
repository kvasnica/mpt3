function test_polyunion_02_pass
%
% empty polyunion array
%

U = [PolyUnion;PolyUnion];

for i=1:2
    if U(i).Num~=0
        error('must be empty');
    end
end

end