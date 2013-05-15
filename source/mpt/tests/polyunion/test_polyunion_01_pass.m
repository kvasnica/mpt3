function test_polyunion_01_pass
%
% empty polyunion object
%

U = PolyUnion;

if U.Num~=0
    error('must be empty');
end

end